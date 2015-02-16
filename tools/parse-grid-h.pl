@files = ('/usr/local/include/ral2/grid.h',
          '/usr/local/include/ral2/grid/dem.h',
          '/usr/local/include/ral2/grid/image.h',
          '/usr/local/include/ral2/grid/io.h',
          '/usr/local/include/ral2/grid/neighborhood.h',
          '/usr/local/include/ral2/grid/rasterize.h',
          '/usr/local/include/ral2/grid/resample.h',
          '/usr/local/include/ral2/grid/statistics.h');
my $h = '';
for my $f (@files) {
    open(my $fh, "<", $f) or die "cannot open < $f: $!";
    while (<$fh>) {
        chomp;
        next if /^#/;
        $h .= $_;
    }
    close $fh;
}
$h =~ s/\/\*.*?\*\///g;
@exp = split /;/, $h;
my %exp;
for (@exp) {
    s/^\s+//;
    s/\s+$//;
    s/RAL_CALL//;
    s/\s+/ /g;
    s/ \* / */g;
    next if /^extern/;
    next if /^typedef/;
    if ((not /\(ral_grid_t \*/ and not /^ral_grid_t \*/) or (/variogram_function/)) {
        print STDERR "not: $_\n";
        next;
    }
    if (/(\w+)\(/) {
        $pre = $1;
        my($p) = $pre =~ /^([a-z]+_[a-z]+)/;
        push @{$exp{$p}}, $_;
    }
}

$f = 'lib/Geo/Raster2.xs';
open(my $fh, ">", $f) or die "cannot open > $f: $!";

my $preamble = <<'END_PREAMBLE';
/* do not edit - this file was created with /tools/parse-grid-h.pl */
#include "EXTERN.h"
#include "perl.h"
#define NO_XSLOCKS
#include "XSUB.h"
#include <gtk2-ex-geo.h>
#include <ral2/ral.h>
#include "help.c"

MODULE = Geo::Raster2		PACKAGE = Geo::Raster2::Grid		PREFIX = ral_grid_

PROTOTYPES: ENABLE

BOOT:
{
  (void) hv_store(PL_modglobal, "Geo::Raster2::V2ral", 18,
                  newSViv(PTR2IV(perl_variable_to_ral_object)), 0);
  (void) hv_store(PL_modglobal, "Geo::Raster2::ral2V", 18,
                  newSViv(PTR2IV(ral_object_to_perl_variable)), 0);
}

END_PREAMBLE

print $fh $preamble;

my @pre = qw/ral_grid ral_dem ral_fdg ral_streams ral_water/;
for my $pre (@pre) {
    my $prefix = $pre.'_';
    print $fh "MODULE = Geo::Raster2\t\tPACKAGE = Geo::Raster2::Grid\t\tPREFIX = $prefix\n\n";
    for my $fct (@{$exp{$pre}}) {

        my $e = 0;
        if ($fct =~ /ral_error_t/) {
            $fct =~ s/, ral_error_t \*\*e//;
            $e = 1;
            $body = $fct;
            ($retval) = $fct =~ /([\w]+ [*]*)/;
            $body =~ s/([\w]+ [*]*)//;
            ($args) = $body =~ /\((.*?)\)/;
            @args = split /,/, $args;
            for (@args) {
                s/([\w]+ [*]*)//;
            }
            $args = join ',', @args;
            $body =~ s/\(.*?\)/()/;
            $body =~ s/\)/$args, &e)/;
        }

        print $fh "$fct\n";
        if ($e) {
            print $fh "    CODE:\n";
            print $fh "    ral_error_t *e = NULL;\n";
            print $fh "    dXCPT;\n";
            print $fh "    XCPT_TRY_START {\n";
            if ($retval ne 'void ') {
                print $fh "        RETVAL = $body;\n";
            } else {
                print $fh "        $body;\n";
            }
            print $fh "        if (e && ral_error_level(e) == 0) croak(\"%s\", ral_as_string(e));\n";
            print $fh "        if (e && ral_error_level(e) == 1) warn(\"%s\", ral_as_string(e));\n";
            if ($retval ne 'void ') {
                print $fh "        if (!RETVAL) croak(\"Call failed. Probably out of memory.\");\n";
            }
            print $fh "    } XCPT_TRY_END\n";
            print $fh "    XCPT_CATCH {\n";
            print $fh "        if (e) ral_delete(e);\n";
            print $fh "        XCPT_RETHROW;\n";
            print $fh "    }\n";
            if ($retval ne 'void ') {
                print $fh "    OUTPUT:\n";
                print $fh "    RETVAL\n";
            }
        }
        print $fh "\n";

    }
}

my $post = <<'END_POST';
MODULE = Geo::Raster2		PACKAGE = Geo::Raster2::Pixbuf		PREFIX = ral_pixbuf_

ral_pixbuf_t *ral_pixbuf_new_from_gtk2_ex_geo_pixbuf(gtk2_ex_geo_pixbuf *pb)
    CODE:
    ral_pixbuf_t * r = ral_new(ralPixbuf);
    if (r) {
        ral_pixbuf_create_from_data(r,
                                    pb->image,
                                    pb->image_rowstride,
                                    pb->pixbuf,
                                    pb->destroy_fn,
                                    pb->colorspace,
                                    pb->has_alpha,
                                    pb->rowstride,
                                    pb->bits_per_sample,
                                    pb->width,
                                    pb->height,
                                    pb->world_min_x,
                                    pb->world_max_y - pb->height * pb->pixel_size,
                                    pb->world_min_x + pb->width * pb->pixel_size,
                                    pb->world_max_y,
                                    pb->pixel_size);
        RETVAL = r;
    } else
        RETVAL = NULL;
    OUTPUT:
    RETVAL

void ral_pixbuf_render_grid(ral_pixbuf_t * pb, ral_grid_t *gd, ral_hash_t *style)
    CODE:
    if (!style) croak("usage: render_grid(ral_pixbuf_t*, ral_grid_t*, hashref)");
    ral_layer_t *l = (ral_layer_t *)ral_raster_new_from_grid(gd);
    ral_error_t *e = NULL;
    ral_render(l, (ral_output_device_t *)pb, style, &e);
    ral_delete(style);
    ral_delete(l);
    if (e) croak("%s", ral_as_string(e));

END_POST

print $fh $post;
