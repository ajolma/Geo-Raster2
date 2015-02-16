package Geo::Raster2;

use strict;
use warnings;
use Carp;
use POSIX;
POSIX::setlocale( &POSIX::LC_NUMERIC, "C" ); # http://www.gdal.org/faq.html nr. 12
use Scalar::Util 'blessed';
use Geo::GDAL;

our $VERSION = '0.01';

require Exporter;
require DynaLoader;

our @ISA = qw( Exporter DynaLoader );

our @EXPORT = qw();

our %EXPORT_TAGS = (types  => [ qw ( ) ],
		    logics => [ qw ( not and or ) ] );

our @EXPORT_OK = qw ( not and or );

our $AUTOLOAD;

sub dl_load_flags {0x01}

bootstrap Geo::Raster2 $VERSION;

sub AUTOLOAD {
    my $self = shift;
    (my $sub = $AUTOLOAD) =~ s/.*:://;
    if ($self->{GDAL} and $sub =~ /^[A-Z]/) {
	unshift @_, $self->band();
	goto '&Geo::GDAL::Band::'.$sub;
    } else {
        unshift @_, $self->{GRID};
        goto '&Geo::Raster2::Grid::'.$sub;
    }
}

sub new {
    my $package = shift;
    my $self = {};
    bless $self => (ref($package) or $package);
    return $self;
}

sub DESTROY {
    my $self = shift;
}

package Geo::Raster2::Grid;

use strict;
use Carp;
use overload (
    'fallback' => undef,
    # not having "" overloaded makes print "$grid" to print "1"
    '""'       => 'pl_as_string', 
    'bool'     => 'pl_bool',
    '='        => 'pl_shallow_copy',
    'neg'      => 'pl_neg',
    '+'        => 'pl_plus',
    '-'        => 'pl_minus',              
    '*'        => 'pl_times',
    '/'        => 'pl_over',
    '%'        => 'pl_modulo',
    '**'       => 'pl_power',
    '+='       => 'pl_add',
    '-='       => 'pl_subtract',
    '*='       => 'pl_multiply_by',
    '/='       => 'pl_divide_by',
    '%='       => 'pl_modulus_with',
    '**='      => 'pl_to_power_of',
    'atan2'    => 'pl_atan2',
    'cos'      => 'pl_cos',
    'sin'      => 'pl_sin',
    'exp'      => 'pl_exp',
    'abs'      => 'pl_abs',
    'log'      => 'pl_log',
    'sqrt'     => 'pl_sqrt',
    '<'        => 'pl_lt',
    '>'        => 'pl_gt',
    '<='       => 'pl_le',
    '>='       => 'pl_ge',
    '=='       => 'pl_eq',
    '!='       => 'pl_ne',
    '<=>'      => 'pl_cmp',
    );
use Scalar::Util;

sub DESTROY {
    my $self = shift;
    $self->delete;
}

sub pl_as_string {
    my $self = shift;
    return $self;
}

sub pl_bool {
    return 1;
}

sub pl_shallow_copy {
    my $self = shift;
    return $self;
}

sub pl_neg {
    my $self = shift;
    my $copy = $self->new_copy($self->get_type);
    $copy->mult(-1);
    return $copy;
}

sub typeconversion {
    my($self, $other) = @_;
    my $type = $self->get_type;
    if (ref($other)) {
        if (Scalar::Util::blessed($other) and $other->isa('Geo::Raster2::Grid')) {
            return 'real' if $other->get_type eq 'real' or $type eq 'real';
            return 'integer';
        } else {
            croak "other is not a Geo::Raster2::Grid\n";
        }
    } else {
        return $type if $other =~ /^-?\d+$/; # perlfaq4: is scalar an integer ?
        if ($other =~ /^([+-]?)(?=\d|\.\d)\d*(\.\d*)?([Ee]([+-]?\d+))?$/) { # perlfaq4: is scalar a C float ?
            return 'real' if $type eq 'integer';
            return $type;
        }
        croak "other is not numeric\n";
    }
}

sub pl_plus {
    my($self, $second) = @_;
    my $type = $self->typeconversion($second);
    my $copy = $self->new_copy($type);
    if (Scalar::Util::blessed($second) and $second->isa('Geo::Raster2::Grid')) {
        $copy->add_grid($second);
    } else {
        $copy->add($second);
    }
    return $copy;
}

sub pl_minus {
    my($self, $second, $reversed) = @_;
    my $type = $self->typeconversion($second);
    my $copy = $self->new_copy($type);
    if (Scalar::Util::blessed($second) and $second->isa('Geo::Raster2::Grid')) {
        ($copy, $second) = ($second, $copy) if $reversed;
        $copy->sub_grid($second);
    } else {
        if ($reversed) {
            $copy->mult(-1);
        } else {
            $second *= -1;
        }
        $copy->add($second);
    }
    return $copy;
}

sub pl_times {
    my($self, $second) = @_;
    my $type = $self->typeconversion($second);
    my $copy = $self->new_copy($type);
    if (Scalar::Util::blessed($second) and $second->isa('Geo::Raster2::Grid')) {
        $copy->mult_grid($second);
    } else {
        $copy->mult($second);
    }
    return $copy;
}

sub pl_over {
    my($self, $second, $reversed) = @_;
    my $copy = $self->new_copy('real');
    if (Scalar::Util::blessed($second) and $second->isa('Geo::Raster2::Grid')) {
        ($copy, $second) = ($second, $copy) if $reversed;
        $copy->div_grid($second);
    } else {
        $copy->div($second, $reversed);
    }
    return $copy;
}

sub pl_modulo {
    my($self, $second, $reversed) = @_;
    my $copy = $self->new_copy('integer');
    if (Scalar::Util::blessed($second) and $second->isa('Geo::Raster2::Grid')) {
        ($copy, $second) = ($second, $copy) if $reversed;
        $copy->modulus_grid($second);
    } else {
        $copy->modulus($second, $reversed);
    }
    return $copy;
}

sub pl_power {
    my($self, $second, $reversed) = @_;
    my $type = $self->typeconversion($second);
    my $copy = $self->new_copy($type);
    if (Scalar::Util::blessed($second) and $second->isa('Geo::Raster2::Grid')) {
        ($copy, $second) = ($second, $copy) if $reversed;
        $copy->power_grid($second);
    } else {
        $copy->power($second, $reversed);
    }
    return $copy;
}

sub pl_add {
    my($self, $second) = @_;
    my $type = $self->typeconversion($second);
    $self = $self->new_copy($type) if $type ne $self->get_type;
    if (Scalar::Util::blessed($second) and $second->isa('Geo::Raster2::Grid')) {
        $self->add_grid($second);
    } else {
        $self->add($second);
    }
    return $self;
}

sub pl_subtract {
    my($self, $second) = @_;
    my $type = $self->typeconversion($second);
    $self = $self->new_copy($type) if $type ne $self->get_type;
    if (Scalar::Util::blessed($second) and $second->isa('Geo::Raster2::Grid')) {
        $self->sub_grid($second);
    } else {
        $self->add(-$second);
    }
    return $self;
}

sub pl_multiply_by {
    my($self, $second) = @_;
    my $type = $self->typeconversion($second);
    $self = $self->new_copy($type) if $type ne $self->get_type;
    if (Scalar::Util::blessed($second) and $second->isa('Geo::Raster2::Grid')) {
        $self->mult_grid($second);
    } else {
        $self->mult($second);
    }
    return $self;
}

sub pl_divide_by {
    my($self, $second) = @_;
    $self = $self->new_copy('real');
    if (Scalar::Util::blessed($second) and $second->isa('Geo::Raster2::Grid')) {
        $self->div_grid($second);
    } else {
        $self->div($second);
    }
    return $self;
}

sub pl_modulus_with {
    my($self, $second) = @_;
    if (Scalar::Util::blessed($second) and $second->isa('Geo::Raster2::Grid')) {
        $self->modulus_grid($second);
    } else {
        $self->modulus($second, 0);
    }
    return $self;
}

sub pl_to_power_of {
    my($self, $second) = @_;
    my $type = $self->typeconversion($second);
    $self = $self->new_copy($type) if $type ne $self->get_type;
    if (Scalar::Util::blessed($second) and $second->isa('Geo::Raster2::Grid')) {
        $self->power_grid($second);
    } else {
        $self->power($second, 0);
    }
    return $self;
}

sub pl_atan2 {
    my($self, $second) = @_;
    if (Scalar::Util::blessed($second) and $second->isa('Geo::Raster2::Grid')) {
        $self = $self->new_copy('real') if defined wantarray;
        $self->atan2($second);
        return $self if defined wantarray;
    } else {
        croak "Don't mix scalars and rasters in atan2, please.";
    }
}

sub pl_cos {
    my $self = shift;
    $self = $self->new_copy('real') if defined wantarray;
    $self->cos();
    return $self if defined wantarray;
}

sub pl_sin {
    my $self = shift;
    $self = $self->new_copy('real') if defined wantarray;
    $self->sin();
    return $self if defined wantarray;
}

sub pl_exp {
    my $self = shift;
    $self = $self->new_copy('real') if defined wantarray;
    $self->exp();
    return $self if defined wantarray;
}

sub pl_abs {
    my $self = shift;
    $self = $self->new_copy($self->get_type)if defined wantarray;
    $self->abs();
    return $self if defined wantarray;
}

sub pl_log {
    my $self = shift;
    $self = $self->new_copy($self->get_type)if defined wantarray;
    $self->log();
    return $self if defined wantarray;
}

sub pl_sqrt {
    my $self = shift;
    $self = $self->new_copy($self->get_type) if defined wantarray;
    $self->sqrt();
    return $self if defined wantarray;
}

sub pl_lt {
    my($self, $second, $reversed) = @_;
    $self = $self->new_copy($self->get_type) if defined wantarray;
    if (Scalar::Util::blessed($second) and $second->isa('Geo::Raster2::Grid')) {
        $self->lt_grid($second);
    } else {
        if ($reversed) {
            $self->gt($second);
        } else  {
            $self->lt($second);
        }
    }
    return $self if defined wantarray;
}

sub pl_gt {
    my($self, $second, $reversed) = @_;
    $self = $self->new_copy($self->get_type) if defined wantarray;
    if (Scalar::Util::blessed($second) and $second->isa('Geo::Raster2::Grid')) {
        $self->gt_grid($second);
    } else {
        if ($reversed) {
            $self->lt($second);
        } else  {
            $self->gt($second);
        }
    }
    return $self if defined wantarray;
}

sub pl_le {
    my($self, $second, $reversed) = @_;
    $self = $self->new_copy($self->get_type) if defined wantarray;
    if (Scalar::Util::blessed($second) and $second->isa('Geo::Raster2::Grid')) {
        $self->le_grid($second);
    } else {
        if ($reversed) {
            $self->ge($second);
        } else  {
            $self->le($second);
        }
    }
    return $self if defined wantarray;
}

sub pl_ge {
    my($self, $second, $reversed) = @_;
    $self = $self->new_copy($self->get_type) if defined wantarray;
    if (Scalar::Util::blessed($second) and $second->isa('Geo::Raster2::Grid')) {
        $self->ge_grid($second);
    } else {
        if ($reversed) {
            $self->le($second);
        } else  {
            $self->ge($second);
        }
    }
    return $self if defined wantarray;
}

sub pl_eq {
    my($self, $second) = @_;
    $self = $self->new_copy($self->get_type) if defined wantarray;
    if (Scalar::Util::blessed($second) and $second->isa('Geo::Raster2::Grid')) {
        $self->eq_grid($second);
    } else {
        $self->eq($second);
    }
    return $self if defined wantarray;
}

sub pl_ne {
    my($self, $second) = @_;
    $self = $self->new_copy($self->get_type) if defined wantarray;
    if (Scalar::Util::blessed($second) and $second->isa('Geo::Raster2::Grid')) {
        $self->ne_grid($second);
    } else {
        $self->ne($second);
    }
    return $self if defined wantarray;
}

sub pl_cmp {
    my($self, $second, $reversed) = @_;
    $self = $self->new_copy($self->get_type) if defined wantarray;
    if (Scalar::Util::blessed($second) and $second->isa('Geo::Raster2::Grid')) {
        $self->cmp_grid($second);
    } else {
        $self->cmp($second);
        if ($reversed) {
            $self->mult(-1);
        }
    }
    return $self if defined wantarray;
}

# not, and, or
# round
# abs, acos, atan, atan2, ceil, cos, cosh, exp, floor, log, log10, pow, sin, sinh, sqrt, tan, tanh,
# min, max, min, random

package Geo::Raster2::Grid::Layer;

use Scalar::Util;

our @ISA = qw(Gtk2::Ex::Geo::Layer);

sub registration {
    return { dialogs => undef, commands => undef };
}

sub upgrade {
    my($object) = @_;
    if (Scalar::Util::blessed($object) and $object->isa('Geo::Raster2::Grid')) {
        my $layer = { Grid => $object };        
	bless($layer, 'Geo::Raster2::Grid::Layer');
        $layer->defaults();
        return $layer;
    }
    return 0;
}

sub world {
    my($self) = @_;
    my $w = $self->{Grid}->get_world;
    return @$w;
}
    
sub name {
    my($self, $name) = @_;
    #defined $name ? $self->{NAME} = $name : $self->{NAME};
    return 'test';
}

sub render {
    my($self, $pb, $cr, $overlay, $viewport) = @_;
    print STDERR "$pb\n";
    $pb = Geo::Raster2::Pixbuf::new_from_gtk2_ex_geo_pixbuf($pb);
    $pb->render_grid($self->{Grid}, $self->{Style});
}

sub statusbar_info {
    my($self, $x, $y) = @_;
    my $cell = $self->{Grid}->point2cell([$x, $y]);
    my $value = $self->{Grid}->get($cell);
    return "(col,row)=($cell->[0],$cell->[1]) value=$value";
}

package Geo::Raster2::GDAL::Layer;

use Scalar::Util;

our @ISA = qw(Gtk2::Ex::Geo::Layer);

sub registration {
    return { dialogs => undef, commands => undef };
}

sub upgrade {
    my($object) = @_;
    if (Scalar::Util::blessed($object) and $object->isa('Geo::GDAL::Dataset')) {
        my $layer = { Dataset => $object };        
	bless($layer, 'Geo::Raster2::GDAL::Layer');
        $layer->defaults();
        return $layer;
    }
    return 0;
}

sub world {
    my($self) = @_;
    my @t = $self->{Dataset}->GeoTransform();
    my $h = $self->{Dataset}->{RasterYSize};
    my $w = $self->{Dataset}->{RasterXSize};
        
    my $min_x = $t[0] + $t[1]*0 + $t[2]*0; 
    my $min_y = $t[3] + $t[4]*0 + $t[5]*0;
    my $max_x = $min_x;
    my $max_y = $min_y;
    my $x = $t[0] + $t[1]*0 + $t[2]*$h; 
    my $y = $t[3] + $t[4]*0 + $t[5]*$h;
    $min_x = $x if $x < $min_x;
    $min_y = $y if $y < $min_y;
    $max_x = $x if $x > $max_x;
    $max_y = $y if $y > $max_y;
    $x = $t[0] + $t[1]*$w + $t[2]*$h; 
    $y = $t[3] + $t[4]*$w + $t[5]*$h;
    $min_x = $x if $x < $min_x;
    $min_y = $y if $y < $min_y;
    $max_x = $x if $x > $max_x;
    $max_y = $y if $y > $max_y;
    $x = $t[0] + $t[1]*$w + $t[2]*0; 
    $y = $t[3] + $t[4]*$w + $t[5]*0;
    $min_x = $x if $x < $min_x;
    $min_y = $y if $y < $min_y;
    $max_x = $x if $x > $max_x;
    $max_y = $y if $y > $max_y;
    
    return ($min_x, $min_y, $max_x, $max_y);
}
    
sub name {
    my($self, $name) = @_;
    #defined $name ? $self->{NAME} = $name : $self->{NAME};
    return 'test';
}

sub render {
    my($self, $pb, $cr, $overlay, $viewport) = @_;
    
    my $clip = $pb->get_world();
    my $pixel_size = $pb->get_pixel_size();

    if ($clip->[1] > $clip->[3]) { # cope with ul,dr
        my $tmp = $clip->[3];
        $clip->[3] = $clip->[1];
        $clip->[1] = $tmp;
    }
    my $t = $self->{Dataset}->GetGeoTransform;
    my $cell_size = abs($t->[1]);
    $cell_size = $pixel_size if $pixel_size > $cell_size;

    my $band = 1;
    my $gd = Geo::Raster2::Grid::new_using_GDAL($self->{Dataset}, $band, $clip, $cell_size);

    $pb = Geo::Raster2::Pixbuf::new_from_gtk2_ex_geo_pixbuf($pb);
    $pb->render_grid($gd, $self->{Style});
}

sub statusbar_info {
    my($self, $x, $y) = @_;
    return '';
}

1;
__END__
