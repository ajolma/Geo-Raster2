use UNIVERSAL;
use Test::More qw(no_plan);

BEGIN {
    use_ok( 'Geo::Raster2' );
}

# test new

for my $type (qw/integer real/) {
    my $a = Geo::Raster2::Grid::new($type, 2, 3);
    ok($a->get_type eq $type, "type");
    ok($a->get_width == 2, "width");
    ok($a->get_height == 3, "height");
    my $no_data = $a->get_no_data_value;
    ok(!defined($no_data), "get no_data");
    $a->set_no_data_value(-1);
    $no_data = $a->get_no_data_value;
    ok($no_data == -1, "set no_data");
    eval {
        $a->set_no_data_value(-99999999999);
    };
    if ($type eq 'integer') {
        ok($@, "no_data error: $@");
    } else {
        my $diff = abs($a->get_no_data_value- -99999999999);
        ok($diff < 3000, "no_data error: $diff");
    }
}

# test new like

for my $type (qw/integer real/) {
    my $a = Geo::Raster2::Grid::new($type, 2, 3);
    $b = $a->new_like($type eq 'integer' ? 'real' : 'integer');
    ok($a->get_width == $b->get_width, "width");
    ok($a->get_type ne $b->get_type, "type");
}

# test new copy

for my $type (qw/integer real/) {
    my $a = Geo::Raster2::Grid::new($type, 2, 3);
    for my $x (0..1) {
        for my $y (0..2) {
            $a->set([$x, $y], $x*$y-1);
        }
    }
    $b = $a->new_copy($type eq 'integer' ? 'real' : 'integer');
    ok($a->get_width == $b->get_width, "width");
    ok($a->get_type ne $b->get_type, "type");
    for my $x (0..1) {
        for my $y (0..2) {
            ok($b->get([$x, $y]) == $x*$y-1, "set, copy, get");
        }
    }
    
}

# test as_string

for my $type (qw/integer real/) {
    my $a = Geo::Raster2::Grid::new($type, 2, 3);
    $b = "$a";
    ok($b =~ /^Geo::Raster2::Grid/, "as string");
}

# test neg and plus

for my $type (qw/integer real/) {
    my $a = Geo::Raster2::Grid::new($type, 2, 3);
    for my $x (0..1) {
        for my $y (0..2) {
            $a->set([$x, $y], $x*$y-1);
        }
    }
    my $b = -$a;
    for my $x (0..1) {
        for my $y (0..2) {
            ok($b->get([$x, $y]) == 1-$x*$y, "neg");
        }
    }
    my $c = $a+$b;
    for my $x (0..1) {
        for my $y (0..2) {
            ok($c->get([$x, $y]) == 0, "plus");
        }
    }
}


# test minus
for my $type (qw/integer real/) {
    my $a = Geo::Raster2::Grid::new($type, 2, 3);
    for my $x (0..1) {
        for my $y (0..2) {
            $a->set([$x, $y], $x*$y-1);
        }
    }
    $b = $a-$a;
    $c = $a-1;
    $d = 1-$a;    
    for my $x (0..1) {
        for my $y (0..2) {
            ok($b->get([$x, $y]) == 0, "b minus");
            ok($c->get([$x, $y]) == $x*$y-1-1, "c minus");
            ok($d->get([$x, $y]) == 1-($x*$y-1), "d minus");
        }
    }
}

# test some functions
for my $fct (qw/log sin cos exp sqrt/) {
    for my $type (qw/integer real/) {
        my $a = Geo::Raster2::Grid::new($type, 2, 3);
        for my $x (0..1) {
            for my $y (0..2) {
                $a->set([$x, $y], $x*$y+4);
            }
        }
        my $b;
        eval "\$b = $fct(\$a); \$a->$fct;";
        for my $x (0..1) {
            for my $y (0..2) {
                my $adiff;
                my $bdiff;
                eval 
                    "\$adiff = \$a->get([\$x, \$y]) - $fct(\$x*\$y+4);".
                    "\$bdiff = \$b->get([\$x, \$y]) - $fct(\$x*\$y+4);";
                ok($adiff < 0.01, "a $fct $adiff");
                ok($bdiff < 0.01, "b $fct $bdiff");
            }
        }
    }
}

# test comparisons
for my $fct (qw/< > <= >= == != <=>/) {
    for my $type (qw/integer real/) {
        my $a = Geo::Raster2::Grid::new($type, 2, 3);
        my $b = Geo::Raster2::Grid::new($type, 2, 3);
        for my $x (0..1) {
            for my $y (0..2) {
                $a->set([$x, $y], $x+$y);
                $b->set([$x, $y], 3-$x-$y);
            }
        }
        my $c;
        eval "\$c = \$a $fct \$b;";
        for my $x (0..1) {
            for my $y (0..2) { 
                my $diff;
                eval "\$diff = \$c->get([\$x, \$y]) - ((\$x+\$y) $fct (3-\$x-\$y));";
                ok($diff < 0.01, "comparison $fct ret = $diff");
            }
        }
    }
}
