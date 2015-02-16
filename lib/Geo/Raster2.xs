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

MODULE = Geo::Raster2		PACKAGE = Geo::Raster2::Grid		PREFIX = ral_grid_

ral_grid_t *ral_grid_new(ral_grid_type_t type, int width, int height)

ral_grid_t *ral_grid_new_like(ral_grid_t *gd, ral_grid_type_t type)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_new_like(gd, type, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

ral_grid_t *ral_grid_new_copy(ral_grid_t *gd, ral_grid_type_t type)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_new_copy(gd, type, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

void ral_grid_delete(ral_grid_t *gd)

void *ral_grid_data(ral_grid_t *gd)

int ral_grid_get_height(ral_grid_t *gd)

int ral_grid_get_width(ral_grid_t *gd)

ral_grid_type_t ral_grid_get_type(ral_grid_t *gd)

double ral_grid_get_cell_size(ral_grid_t *gd)

ral_wbox_t *ral_grid_get_world(ral_grid_t *gd)

ral_object_t *ral_grid_get_no_data_value(ral_grid_t *gd)

int ral_grid_set_no_data_value(ral_grid_t *gd, ral_object_t *value)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_set_no_data_value(gd, value, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

void ral_grid_flip_horizontal(ral_grid_t *gd)

void ral_grid_flip_vertical(ral_grid_t *gd)

int ral_grid_coerce(ral_grid_t *gd, ral_grid_type_t type)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_coerce(gd, type, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_grid_overlayable(ral_grid_t *g1, ral_grid_t *g2)

void ral_grid_set_bounds(ral_grid_t *gd, double cell_size, double minX, double minY)

void ral_grid_copy_bounds(ral_grid_t *from, ral_grid_t *to)

ral_rcoords_t *ral_grid_point2cell(ral_grid_t *gd, ral_wcoords_t *p)

ral_wcoords_t *ral_grid_cell2point(ral_grid_t *gd, ral_rcoords_t *c)

ral_wcoords_t *ral_grid_cell2point_upleft(ral_grid_t *gd, ral_rcoords_t *c)

ral_object_t *ral_grid_get(ral_grid_t *gd, ral_rcoords_t *c)

void ral_grid_set(ral_grid_t *gd, ral_rcoords_t *c, ral_object_t *value)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        ral_grid_set(gd, c, value, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }

int ral_grid_is_defined(ral_grid_t *gd)

int ral_grid_not(ral_grid_t *gd)

int ral_grid_and_grid(ral_grid_t *gd1, ral_grid_t *gd2)

int ral_grid_or_grid(ral_grid_t *gd1, ral_grid_t *gd2)

void ral_grid_add(ral_grid_t *gd, ral_object_t *x)

int ral_grid_add_grid(ral_grid_t *gd1, ral_grid_t *gd2)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_add_grid(gd1, gd2, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_grid_sub_grid(ral_grid_t *gd1, ral_grid_t *gd2)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_sub_grid(gd1, gd2, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

void ral_grid_mult(ral_grid_t *gd, ral_object_t *x)

int ral_grid_mult_grid(ral_grid_t *gd1, ral_grid_t *gd2)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_mult_grid(gd1, gd2, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

void ral_grid_div(ral_grid_t *gd, ral_object_t *x, int reversed)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        ral_grid_div(gd, x, reversed, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }

int ral_grid_div_grid(ral_grid_t *gd1, ral_grid_t *gd2)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_div_grid(gd1, gd2, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

void ral_grid_modulus(ral_grid_t *gd, int x, int reversed)

int ral_grid_modulus_grid(ral_grid_t *gd1, ral_grid_t *gd2)

void ral_grid_power(ral_grid_t *gd, double x, int reversed)

int ral_grid_power_grid(ral_grid_t *gd1, ral_grid_t *gd2)

ral_grid_t *ral_grid_round(ral_grid_t *gd)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_round(gd, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_grid_abs(ral_grid_t *gd)

int ral_grid_acos(ral_grid_t *gd)

int ral_grid_atan(ral_grid_t *gd)

int ral_grid_atan2(ral_grid_t *gd1, ral_grid_t *gd2)

int ral_grid_ceil(ral_grid_t *gd)

int ral_grid_cos(ral_grid_t *gd)

int ral_grid_cosh(ral_grid_t *gd)

int ral_grid_exp(ral_grid_t *gd)

int ral_grid_floor(ral_grid_t *gd)

int ral_grid_log(ral_grid_t *gd)

int ral_grid_log10(ral_grid_t *gd)

int ral_grid_pow(ral_grid_t *gd, ral_object_t *value)

int ral_grid_sin(ral_grid_t *gd)

int ral_grid_sinh(ral_grid_t *gd)

int ral_grid_sqrt(ral_grid_t *gd)

int ral_grid_tan(ral_grid_t *gd)

int ral_grid_tanh(ral_grid_t *gd)

int ral_grid_lt(ral_grid_t *gd, ral_object_t *x)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_lt(gd, x, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_grid_gt(ral_grid_t *gd, ral_object_t *x)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_gt(gd, x, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_grid_le(ral_grid_t *gd, ral_object_t *x)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_le(gd, x, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_grid_ge(ral_grid_t *gd, ral_object_t *x)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_ge(gd, x, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_grid_eq(ral_grid_t *gd, ral_object_t *x)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_eq(gd, x, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_grid_ne(ral_grid_t *gd, ral_object_t *x)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_ne(gd, x, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_grid_cmp(ral_grid_t *gd, ral_object_t *x)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_cmp(gd, x, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_grid_lt_grid(ral_grid_t *gd1, ral_grid_t *gd2)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_lt_grid(gd1, gd2, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_grid_gt_grid(ral_grid_t *gd1, ral_grid_t *gd2)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_gt_grid(gd1, gd2, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_grid_le_grid(ral_grid_t *gd1, ral_grid_t *gd2)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_le_grid(gd1, gd2, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_grid_ge_grid(ral_grid_t *gd1, ral_grid_t *gd2)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_ge_grid(gd1, gd2, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_grid_eq_grid(ral_grid_t *gd1, ral_grid_t *gd2)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_eq_grid(gd1, gd2, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_grid_ne_grid(ral_grid_t *gd1, ral_grid_t *gd2)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_ne_grid(gd1, gd2, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_grid_cmp_grid(ral_grid_t *gd1, ral_grid_t *gd2)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_cmp_grid(gd1, gd2, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

void ral_grid_min(ral_grid_t *gd, ral_object_t *x)

void ral_grid_max(ral_grid_t *gd, ral_object_t *x)

int ral_grid_min_grid(ral_grid_t *gd1, ral_grid_t *gd2)

int ral_grid_max_grid(ral_grid_t *gd1, ral_grid_t *gd2)

void ral_grid_random(ral_grid_t *gd)

ral_array_t *ral_grid_get_focal(ral_grid_t *grid, ral_rcoords_t *c, ral_array_t *focus)

ral_object_t *ral_grid_focal_sum(ral_grid_t *grid, ral_rcoords_t *c, ral_array_t *focus)

ral_object_t *ral_grid_focal_mean(ral_grid_t *grid, ral_rcoords_t *c, ral_array_t *focus)

ral_object_t *ral_grid_focal_variance(ral_grid_t *grid, ral_rcoords_t *c, ral_array_t *focus)

ral_object_t *ral_grid_focal_count(ral_grid_t *grid, ral_rcoords_t *c, ral_array_t *focus)

ral_object_t *ral_grid_focal_count_of(ral_grid_t *grid, ral_rcoords_t *c, ral_array_t *focus, RAL_INTEGER value)

ral_interval_t *ral_grid_focal_range(ral_grid_t *grid, ral_rcoords_t *c, ral_array_t *focus)

ral_grid_t *ral_grid_focal_sum_grid(ral_grid_t *grid, ral_array_t *focus)

ral_grid_t *ral_grid_focal_mean_grid(ral_grid_t *grid, ral_array_t *focus)

ral_grid_t *ral_grid_focal_variance_grid(ral_grid_t *grid, ral_array_t *focus)

ral_grid_t *ral_grid_focal_count_grid(ral_grid_t *grid, ral_array_t *focus)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_focal_count_grid(grid, focus, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

ral_grid_t *ral_grid_focal_count_of_grid(ral_grid_t *grid, ral_array_t *focus, RAL_INTEGER value)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_focal_count_of_grid(grid, focus, value, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

ral_hash_t *ral_grid_zonal_count(ral_grid_t *gd, ral_grid_t *zones)

ral_hash_t *ral_grid_zonal_count_of(ral_grid_t *gd, ral_grid_t *zones, RAL_INTEGER value)

ral_hash_t *ral_grid_zonal_sum(ral_grid_t *gd, ral_grid_t *zones)

ral_hash_t *ral_grid_zonal_range(ral_grid_t *gd, ral_grid_t *zones)

ral_hash_t *ral_grid_zonal_min(ral_grid_t *gd, ral_grid_t *zones)

ral_hash_t *ral_grid_zonal_max(ral_grid_t *gd, ral_grid_t *zones)

ral_hash_t *ral_grid_zonal_mean(ral_grid_t *gd, ral_grid_t *zones)

ral_hash_t *ral_grid_zonal_variance(ral_grid_t *gd, ral_grid_t *zones)

ral_hash_t *ral_grid_zonal_contents(ral_grid_t *gd, ral_grid_t *zones)

void ral_grid_set_all(ral_grid_t *gd, ral_object_t *value)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        ral_grid_set_all(gd, value, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }

ral_interval_t *ral_grid_get_value_range(ral_grid_t *gd)

long ral_grid_count(ral_grid_t *gd)

long ral_grid_count_of(ral_grid_t *gd, RAL_INTEGER value)

double ral_grid_sum(ral_grid_t *gd)

double ral_grid_mean(ral_grid_t *gd)

double ral_grid_variance(ral_grid_t *gd)

ral_bin_t *ral_grid_get_histogram(ral_grid_t *gd, ral_array_t *bins)

ral_hash_t *ral_grid_get_contents(ral_grid_t *gd)

ral_grid_t *ral_grid_cross(ral_grid_t *a, ral_grid_t *b)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_cross(a, b, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

void ral_grid_if_then(ral_grid_t *a, ral_grid_t *b, ral_object_t *c)

void ral_grid_if_then_else(ral_grid_t *a, ral_grid_t *b, ral_object_t *c, ral_object_t *d)

void ral_grid_if_then_grid(ral_grid_t *a, ral_grid_t *b, ral_grid_t *c)

void ral_grid_reclassify(ral_grid_t *gd, ral_classifier_t *classifier)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        ral_grid_reclassify(gd, classifier, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }

ral_grid_t *ral_grid_spread(ral_grid_t *grid, ral_array_t *kernel)

ral_grid_t *ral_grid_spread_random(ral_grid_t *grid, ral_array_t *focus)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_spread_random(grid, focus, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

ral_grid_t *ral_grid_borders(ral_grid_t *gd)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_borders(gd, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

ral_grid_t *ral_grid_borders_recursive(ral_grid_t *gd)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_borders_recursive(gd, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

ral_grid_t *ral_grid_new_using_GDAL(GDALDatasetH dataset, int band, ral_wbox_t *clip_region, double cell_size)

int ral_grid_print(ral_grid_t *gd)

int ral_grid_save_ascii(ral_grid_t *gd, char *outfile)

int ral_grid_write(ral_grid_t *gd, char *filename)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_write(gd, filename, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

ral_hash_t *ral_grid_get_neighbors(ral_grid_t *gd)

ral_grid_t *ral_grid_ca_step(ral_grid_t *gd, void *k)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_ca_step(gd, k, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

ral_grid_t *ral_grid_bufferzone(ral_grid_t *gd, int z, double w)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_bufferzone(gd, z, w, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

double ral_grid_zonesize(ral_grid_t *gd, ral_rcoords_t *c)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_zonesize(gd, c, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

ral_grid_t *ral_grid_areas(ral_grid_t *gd, int k)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_areas(gd, k, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_grid_connect(ral_grid_t *gd)

int ral_grid_number_areas(ral_grid_t *gd, int connectivity)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_number_areas(gd, connectivity, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

ral_grid_t *ral_grid_distances(ral_grid_t *gd)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_distances(gd, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

ral_grid_t *ral_grid_directions(ral_grid_t *gd)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_directions(gd, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

ral_rcoords_t *ral_grid_nearest_neighbor(ral_grid_t *gd, ral_rcoords_t *c)

ral_grid_t *ral_grid_nn(ral_grid_t *gd)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_nn(gd, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

ral_grid_t *ral_grid_dijkstra(ral_grid_t *w, ral_rcoords_t *c)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_dijkstra(w, c, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

void ral_grid_line(ral_grid_t *gd, ral_rcoords_t *c1, ral_rcoords_t *c2, ral_object_t *pen)

void ral_grid_filled_rect(ral_grid_t *gd, ral_rcoords_t *c1, ral_rcoords_t *c2, ral_object_t *pen)

int ral_grid_filled_polygon(ral_grid_t *gd, ral_geometry_t *g, ral_object_t *pen)

void ral_grid_filled_circle(ral_grid_t *gd, ral_rcoords_t *c, int r, ral_object_t *pen)

int ral_grid_rasterize_feature(ral_grid_t *gd, OGRFeatureH f, int value_field, OGRFieldType ft)

int ral_grid_rasterize_layer(ral_grid_t *gd, OGRLayerH l, int value_field)

ral_array_t *ral_grid_get_line(ral_grid_t *gd, ral_rcoords_t *c1, ral_rcoords_t *c2)

ral_array_t *ral_grid_get_rect(ral_grid_t *gd, ral_rcoords_t *c1, ral_rcoords_t *c2)

ral_array_t *ral_grid_get_circle(ral_grid_t *gd, ral_rcoords_t *c, int r)

void ral_grid_floodfill(ral_grid_t *gd, ral_grid_t *filled_area, ral_rcoords_t *c, ral_object_t *pen, int connectivity)

ral_grid_t *ral_grid_clip(ral_grid_t *gd, ral_rcoords_t *ul, ral_rcoords_t *dr)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_clip(gd, ul, dr, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

ral_grid_t *ral_grid_join(ral_grid_t *g1, ral_grid_t *g2)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_grid_join(g1, g2, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

void ral_grid_pick(ral_grid_t *dest, ral_grid_t *src)

ral_array_t *ral_grid_variogram(ral_grid_t *gd, double max_lag, int lags)

MODULE = Geo::Raster2		PACKAGE = Geo::Raster2::Grid		PREFIX = ral_dem_

ral_grid_t *ral_dem_aspect(ral_grid_t *dem)

ral_grid_t *ral_dem_slope(ral_grid_t *dem, double z_factor)

ral_grid_t *ral_dem_fdg(ral_grid_t *dem, int method)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_dem_fdg(dem, method, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

ral_grid_t *ral_dem_ucg(ral_grid_t *dem)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_dem_ucg(dem, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_dem_raise_pits(ral_grid_t *dem, double z_limit)

int ral_dem_lower_peaks(ral_grid_t *dem, double z_limit)

int ral_dem_fill_depressions(ral_grid_t *dem, ral_grid_t *fdg)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_dem_fill_depressions(dem, fdg, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_dem_breach(ral_grid_t *dem, ral_grid_t *fdg, int limit)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_dem_breach(dem, fdg, limit, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

MODULE = Geo::Raster2		PACKAGE = Geo::Raster2::Grid		PREFIX = ral_fdg_

ral_rcoords_t *ral_fdg_outlet(ral_grid_t *fdg, ral_grid_t *streams, ral_rcoords_t *c)

int ral_fdg_catchment(ral_grid_t *fdg, ral_grid_t *mark, ral_rcoords_t *c, int m)

int ral_fdg_drain_flat_areas1(ral_grid_t *fdg, ral_grid_t *dem)

int ral_fdg_drain_flat_areas2(ral_grid_t *fdg, ral_grid_t *dem)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_fdg_drain_flat_areas2(fdg, dem, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

ral_grid_t *ral_fdg_depressions(ral_grid_t *fdg, int inc_m)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_fdg_depressions(fdg, inc_m, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_fdg_drain_depressions(ral_grid_t *fdg, ral_grid_t *dem)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_fdg_drain_depressions(fdg, dem, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

ral_grid_t *ral_fdg_path(ral_grid_t *fdg, ral_rcoords_t *c, ral_grid_t *stop)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_fdg_path(fdg, c, stop, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

ral_grid_t *ral_fdg_path_length(ral_grid_t *fdg, ral_grid_t *stop, ral_grid_t *op)

ral_grid_t *ral_fdg_path_sum(ral_grid_t *fdg, ral_grid_t *stop, ral_grid_t *op)

ral_grid_t *ral_fdg_upslope_sum(ral_grid_t *fdg, ral_grid_t *op, int include_self)

ral_grid_t *ral_fdg_upslope_count(ral_grid_t *fdg, ral_grid_t *op, int include_self)

int ral_fdg_kill_extra_outlets(ral_grid_t *fdg, ral_grid_t *lakes, ral_grid_t *uag)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_fdg_kill_extra_outlets(fdg, lakes, uag, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

MODULE = Geo::Raster2		PACKAGE = Geo::Raster2::Grid		PREFIX = ral_streams_

ral_grid_t *ral_streams_subcatchments(ral_grid_t *streams, ral_grid_t *fdg, ral_rcoords_t *c)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_streams_subcatchments(streams, fdg, c, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

ral_grid_t *ral_streams_subcatchments2(ral_grid_t *streams, ral_grid_t *fdg)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_streams_subcatchments2(streams, fdg, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_streams_number(ral_grid_t *streams, ral_grid_t *fdg, ral_rcoords_t *c, int sid0)

int ral_streams_number2(ral_grid_t *streams, ral_grid_t *fdg, int sid0)

int ral_streams_prune(ral_grid_t *streams, ral_grid_t *fdg, ral_grid_t *lakes, ral_rcoords_t *c, double min_l)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_streams_prune(streams, fdg, lakes, c, min_l, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_streams_prune2(ral_grid_t *streams, ral_grid_t *fdg, ral_grid_t *lakes, double min_l)
    CODE:
    ral_error_t *e = NULL;
    dXCPT;
    XCPT_TRY_START {
        RETVAL = ral_streams_prune2(streams, fdg, lakes, min_l, &e);
        if (e && ral_error_level(e) == 0) croak("%s", ral_as_string(e));
        if (e && ral_error_level(e) == 1) warn("%s", ral_as_string(e));
        if (!RETVAL) croak("Call failed. Probably out of memory.");
    } XCPT_TRY_END
    XCPT_CATCH {
        if (e) ral_delete(e);
        XCPT_RETHROW;
    }
    OUTPUT:
    RETVAL

int ral_streams_break(ral_grid_t *streams, ral_grid_t *fdg, ral_grid_t *lakes, int nsid)

int ral_streams_vectorize(ral_grid_t *streams, ral_grid_t *fdg, int row, int col)

MODULE = Geo::Raster2		PACKAGE = Geo::Raster2::Grid		PREFIX = ral_water_

ral_grid_t *ral_water_route(ral_grid_t *water, ral_grid_t *dem, ral_grid_t *fdg, ral_grid_t *k, double r)

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

