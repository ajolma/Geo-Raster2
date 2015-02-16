#include "geo-raster2.h"

ral_object_t *perl_variable_to_ral_object(SV *sv, ral_class class)
{
    /*fprintf(stderr, "convert a perl variable to %s\n", ral_class_name(class));*/

    if (class == ralDataPoint || sv_isobject(sv) && sv_isa(sv, "Gtk2::Ex::Geo::DataPoint")) {
        ral_data_point_t *a = ral_new(ralDataPoint);
        if (SvROK(sv) && SvTYPE(SvRV(sv)) == SVt_PVAV) {
            AV *av = (AV*)SvRV(sv);
            int i;
            ral_integer_t * ri = ral_new(ralInteger);
            for (i = 0; i <= av_len(av); i++) {
                SV **v = av_fetch(av, i, 0);
                ral_integer_set(ri, i);
                ral_insert(a, perl_variable_to_ral_object(*v, ralObject), ri);
            }
            ral_delete(ri);
        }
        return a;
    } else if (class == ralGrayscale || sv_isobject(sv) && sv_isa(sv, "Gtk2::Ex::Geo::Grayscale")) {
        ral_data_point_t * a = NULL;
        ral_data_point_t * b = NULL;
        if (SvROK(sv) && SvTYPE(SvRV(sv)) == SVt_PVAV) {
            AV *av = (AV*)SvRV(sv);
            int i;
            SV **asv = av_fetch(av, 0, 0);
            a = perl_variable_to_ral_object(*asv, ralDataPoint);
            SV **bsv = av_fetch(av, 1, 0);
            b = perl_variable_to_ral_object(*bsv, ralDataPoint);
        }
        ral_grayscale_t * s = ral_new(ralGrayscale);
        ral_linear_interpolation_set_data_points((ral_linear_interpolation_t *)s, a, b);
        return s;
    } else if (class == ralColor || sv_isobject(sv) && sv_isa(sv, "Gtk2::Ex::Geo::Color")) {
        ral_color_t * c = ral_new(ralColor);
        if (SvROK(sv) && SvTYPE(SvRV(sv)) == SVt_PVAV) {
            AV *av = (AV*)SvRV(sv);
            int red, green, blue, alpha;
            SV **v;
            v = av_fetch(av, 0, 0);
            red = SvIV(*v);
            v = av_fetch(av, 1, 0);
            green = SvIV(*v);
            v = av_fetch(av, 2, 0);
            blue = SvIV(*v);
            v = av_fetch(av, 3, 0);
            alpha = SvIV(*v);
            ral_color_set(c, red, green, blue, alpha);
        }
        return c;
    } else if (class == ralBin) {
        ral_bin_t * bin = ral_new(ralBin);
        if (SvROK(sv) && SvTYPE(SvRV(sv)) == SVt_PVAV) {
            AV *av = (AV*)SvRV(sv);
            SV **binsv = av_fetch(av, 0, 0);
            SV **valuesv = av_fetch(av, 1, 0);
            ral_array_t *bins = perl_variable_to_ral_object(*binsv, ralArray);
            ral_array_t *values = perl_variable_to_ral_object(*valuesv, ralArray);
            ral_bin_set(bin, bins, values);
        }
        return bin;
    } else if (class == ralArray) {
        ral_array_t *a = ral_new(ralArray);
        if (SvROK(sv) && SvTYPE(SvRV(sv)) == SVt_PVAV) {
            AV *av = (AV*)SvRV(sv);
            int i;
            ral_integer_t * ri = ral_new(ralInteger);
            for (i = 0; i <= av_len(av); i++) {
                SV **v = av_fetch(av, i, 0);
                ral_integer_set(ri, i);
                ral_insert(a, perl_variable_to_ral_object(*v, ralObject), ri);
            }
            ral_delete(ri);
        }
        /*fprintf(stderr, "object = %s\n", ral_as_string(a));*/
        return a;
    } else if (class == ralRCoords) {
        if (SvROK(sv) && SvTYPE(SvRV(sv)) == SVt_PVAV) {
            long x, y;
            AV *av = (AV*)SvRV(sv);
            SV **v;
            v = av_fetch(av, 0, 0);
            y = SvIV(*v);
            v = av_fetch(av, 1, 0);
            x = SvIV(*v);
            /*fprintf(stderr, "got rcoords %li %li\n", x, y);*/
            ral_rcoords_t *b = ral_rcoords_new(x, y);
            return b;
        }
        croak("rcoords is [$i, $j]");
    } else if (class == ralWCoords) {
        if (SvROK(sv) && SvTYPE(SvRV(sv)) == SVt_PVAV) {
            double x, y;
            AV *av = (AV*)SvRV(sv);
            SV **v;
            v = av_fetch(av, 0, 0);
            x = SvNV(*v);
            v = av_fetch(av, 1, 0);
            y = SvNV(*v);
            /*fprintf(stderr, "got wcoords %f %f\n", x, y);*/
            ral_wcoords_t *b = ral_wcoords_new(x, y);
            return b;
        }        
        croak("wcoords is [$x, $y]");
    } else if (class == ralWBox) {
        if (SvROK(sv) && SvTYPE(SvRV(sv)) == SVt_PVAV) {
            double xmin, ymin, xmax, ymax;
            AV *av = (AV*)SvRV(sv);
            SV **v;
            v = av_fetch(av, 0, 0);
            xmin = SvNV(*v);
            v = av_fetch(av, 1, 0);
            ymin = SvNV(*v);
            v = av_fetch(av, 2, 0);
            xmax = SvNV(*v);
            v = av_fetch(av, 3, 0);
            ymax = SvNV(*v);
            ral_wbox_t *b = ral_wbox_new(xmin, ymin, xmax, ymax);
            return b;
        }        
        return NULL;
    }
    
    if (class == ralHash) {
        if (!(SvROK(sv) && SvTYPE(SvRV(sv)) == SVt_PVHV))
            return NULL;
    }

    if (!SvOK(sv))
        return ral_undef;
    if (SvIOKp(sv)) {
        ral_integer_t * a = ral_integer_new((long)SvIV(sv));
        return a;
    } else if (SvNOKp(sv)) {
        ral_real_t * a = ral_real_new(SvNV(sv));
        return a;
    } else if (SvPOKp(sv)) {
        ral_string_t * s = ral_new(ralString);
        ral_string_set(s, SvPV_nolen(sv));
        return s;
    } else if (SvROK(sv)) {
        switch(SvTYPE(SvRV(sv))) {
        case SVt_PVAV:;
            ral_array_t *a = ral_new(ralArray);
            AV *av = (AV*)SvRV(sv);
            int i;
            ral_integer_t * ri = ral_new(ralInteger);
            for (i = 0; i <= av_len(av); i++) {
                SV **v = av_fetch(av, i, 0);
                ral_object_t *o = perl_variable_to_ral_object(*v, ralObject);
                if (!o) return NULL;
                ral_integer_set(ri, i);
                ral_insert(a, o, ri);
            }
            ral_delete(ri);
            return a;
        case SVt_PVHV:;
            /*int  sv_isa(SV* sv, const char* name);*/
            ral_hash_t *h = ral_new(ralHash);
            HV *hv = (HV*)SvRV(sv);
            hv_iterinit(hv);
            HE *he;
            while (he = hv_iternext(hv)) {
                I32 retlen;
                char *key = hv_iterkey(he, &retlen);
                SV *val = hv_iterval(hv, he);
                ral_object_t *value = perl_variable_to_ral_object(val, ralObject);
                /*fprintf(stderr, "perl hash: %s => %s\n", key, ral_as_string(value));*/
                if (!value) return NULL;
                ral_string_t *s = ral_new(ralString);
                ral_string_set(s, key);
                ral_insert(h, value, s);
                ral_delete(s);
            }
            return h;
        default:
            fprintf(stderr, "An attempt to convert an unsupported perl reference to ral object. Fail.");
            return NULL;
        }
    } else {/* what to do? */
        fprintf(stderr, "An attempt to convert an unsupported perl variable to ral object. Fail.");
        return NULL;
    }
}

SV *ral_object_to_perl_variable(ral_object_t *obj, int del)
{
    /*fprintf(stderr, "convert %s object (%s) to a perl variable\n", ral_class_name(ral_class_of(obj)), ral_as_string(obj));*/
    if (!obj || obj == ral_undef)
        return newSV(0);
    if (ral_class_of(obj) == ralInteger) {
        SV *sv = newSViv(ral_as_int(obj));
        if (del) ral_delete(obj);
        return sv;
    } else if (ral_class_of(obj) == ralReal) {
        SV *sv = newSVnv(ral_as_real(obj));
        if (del) ral_delete(obj);
        return sv;
    } else if (ral_class_of(obj) == ralString) {
        SV *sv = newSVpv(ral_as_string(obj), 0);
        if (del) ral_delete(obj);
        return sv;
    } else if (ral_class_of(obj) == ralInterval) {
        AV *av = newAV();
        av_store(av, 0, ral_object_to_perl_variable(ral_interval_min((ral_interval_t *)obj), 0));
        av_store(av, 1, ral_object_to_perl_variable(ral_interval_max((ral_interval_t *)obj), 0));
        av_store(av, 2, newSViv(ral_interval_end_point_inclusion((ral_interval_t *)obj)));
        if (del) ral_delete(obj);
        return newRV_inc((SV*)av);
    } else if (ral_class_of(obj) == ralDataPoint) {
        SV *sv = newSVpv(ral_as_string(obj), 0);
        if (del) ral_delete(obj);
        return sv;
    } else if (ral_class_of(obj) == ralLinearInterpolation) {
        SV *sv = newSVpv(ral_as_string(obj), 0);
        if (del) ral_delete(obj);
        return sv;
    } else if (ral_class_of(obj) == ralGrayscale) {
        SV *sv = newSVpv(ral_as_string(obj), 0);
        /*
        SV* sv_bless(SV* sv, HV* stash);
        SV* newSVrv(SV* rv, const char* classname);
        */
        if (del) ral_delete(obj);
        return sv;
    } else if (ral_class_of(obj) == ralHueScale) {
        SV *sv = newSVpv(ral_as_string(obj), 0);
        if (del) ral_delete(obj);
        return sv;
    } else if (ral_class_of(obj) == ralColorComponentScale) {
        SV *sv = newSVpv(ral_as_string(obj), 0);
        if (del) ral_delete(obj);
        return sv;
    } else if (ral_class_of(obj) == ralColor) {
        SV *sv = newSVpv(ral_as_string(obj), 0);
        if (del) ral_delete(obj);
        return sv;
    } else if (ral_class_of(obj) == ralArray) {
        AV *av = newAV();
        int i;
        ral_integer_t * ri = ral_new(ralInteger);
        for (i = 0; i < ral_number_of_elements(obj); i++) {
            ral_integer_set(ri, i);
            av_store(av, i, ral_object_to_perl_variable(ral_lookup(obj, ri), 0));
        }
        ral_delete(ri);
        if (del) ral_delete(obj);
        return newRV_inc((SV*)av);
    } else if (ral_class_of(obj) == ralKVP) {
        SV *sv = newSVpv(ral_as_string(obj), 0);
        if (del) ral_delete(obj);
        return sv;
    } else if (ral_class_of(obj) == ralHash) {
        HV *hv = newHV();
        ral_array_t *keys = ral_keys(obj);
        int i;
        ral_integer_t * ri = ral_new(ralInteger);
        for (i = 0; i < ral_number_of_elements(keys); i++) {
            ral_integer_set(ri, i);
            ral_object_t *key = ral_lookup(keys, ri);
            SV *sv = ral_object_to_perl_variable(ral_lookup(obj, key), 0);
            const char *k = ral_as_string(key);
            int klen = strlen(k);
            hv_store(hv, k, klen, sv, 0);
        }
        ral_delete(ri);
        ral_delete(keys);
        if (del) ral_delete(obj);
        return newRV_inc((SV*)hv);
    } else if (ral_class_of(obj) == ralBin) {
        ral_bin_t * bin = (ral_bin_t *)obj;
        AV *av = newAV();
        AV *av1 = newAV();
        AV *av2 = newAV();
        av_store(av, 0, newRV_inc((SV*)av1));
        av_store(av, 1, newRV_inc((SV*)av2));
        int i, n = ral_number_of_elements(obj);
        for (i = 0; i < n-1; i++) {
            av_store(av1, i, ral_object_to_perl_variable(ral_bin_bin(bin, i), 0));
        }
        for (i = 0; i < n; i++) {
            av_store(av2, i, ral_object_to_perl_variable(ral_bin_value(bin, i), 0));
        }
        if (del) ral_delete(obj);
        return newRV_inc((SV*)av);
    } else if (ral_class_of(obj) == ralRaster) {
        SV *sv = newSVpv(ral_as_string(obj), 0);
        if (del) ral_delete(obj);
        return sv;
    } else if (ral_class_of(obj) == ralRCoords) {
        AV *av = newAV();
        SV *sv = newSViv(ral_rcoords_get_x(obj));
        av_push(av, sv);
        sv = newSViv(ral_rcoords_get_y(obj));
        av_push(av, sv);
        if (del) ral_delete(obj);
        return newRV_inc((SV*)av);
    } else if (ral_class_of(obj) == ralWCoords) {
        AV *av = newAV();
        SV *sv = newSVnv(ral_wcoords_get_x(obj));
        av_push(av, sv);
        sv = newSVnv(ral_wcoords_get_y(obj));
        av_push(av, sv);
        if (del) ral_delete(obj);
        return newRV_inc((SV*)av);
    } else if (ral_class_of(obj) == ralWBox) {
        AV *av = newAV();
        SV *sv = newSVnv(ral_wbox_get_x_min(obj));
        av_push(av, sv);
        sv = newSVnv(ral_wbox_get_y_min(obj));
        av_push(av, sv);
        sv = newSVnv(ral_wbox_get_x_max(obj));
        av_push(av, sv);
        sv = newSVnv(ral_wbox_get_y_max(obj));
        av_push(av, sv);
        if (del) ral_delete(obj);
        return newRV_inc((SV*)av);
    } else if (ral_class_of(obj) == ralVector) {
        SV *sv = newSVpv(ral_as_string(obj), 0);
        if (del) ral_delete(obj);
        return sv;
    } else {
        fprintf(stderr, "An attempt to convert an unsupported ral object to perl variable. Fail.");
        return newSV(0);
    }
}

enum pdl_datatypes { PDL_B, PDL_S, PDL_US, PDL_L, PDL_LL, PDL_F, PDL_D };

RAL_INTEGER int_from_pdl(void *x, int datatype, int i)
{
    switch (datatype) {
    case PDL_L:
    {
	int *xx = (int *) x;
	return (RAL_INTEGER)xx[i];
    }break;
    case PDL_F:
    {
	float *xx = (float *) x;
	return (RAL_INTEGER)xx[i];
    }break;
    case PDL_S:
    {
	short *xx = (short *) x;
	return (RAL_INTEGER)xx[i];
    }break;
    case PDL_US:
    {
	unsigned short *xx = (unsigned short *) x;
	return (RAL_INTEGER)xx[i];
    }break;
    case PDL_D:
    {
	double *xx = (double *) x;
	return (RAL_INTEGER)xx[i];
    }break;
    case PDL_B:
    {
	unsigned char *xx = (unsigned char *) x;
	return (RAL_INTEGER)xx[i];
    }break;
    case PDL_LL:
    {
	long long *xx = (long long *) x;
	return (RAL_INTEGER)xx[i];
    }break;
    default:
	croak ("Not a known data type code=%d", datatype);
    }
}

RAL_REAL real_from_pdl(void *x, int datatype, int i)
{
    switch (datatype) {
    case PDL_L:
    {
	int *xx = (int *) x;
	return (RAL_REAL)xx[i];
    }break;
    case PDL_F:
    {
	float *xx = (float *) x;
	return (RAL_REAL)xx[i];
    }break;
    case PDL_S:
    {
	short *xx = (short *) x;
	return (RAL_REAL)xx[i];
    }break;
    case PDL_US:
    {
	unsigned short *xx = (unsigned short *) x;
	return (RAL_REAL)xx[i];
    }break;
    case PDL_D:
    {
	double *xx = (double *) x;
	return (RAL_REAL)xx[i];
    }break;
    case PDL_B:
    {
	unsigned char *xx = (unsigned char *) x;
	return (RAL_REAL)xx[i];
    }break;
    case PDL_LL:
    {
	long long *xx = (long long *) x;
	return (RAL_REAL)xx[i];
    }break;
    default:
	croak ("Not a known data type code=%d", datatype);
    }
}

IV SV2Handle(SV *sv)
{
    if (SvGMAGICAL(sv))
	mg_get(sv);
    if (!sv_isobject(sv))
	croak("parameter is not an object");
    SV *tsv = (SV*)SvRV(sv);
    if ((SvTYPE(tsv) != SVt_PVHV))
	croak("parameter is not a hashref");
    if (!SvMAGICAL(tsv))
	croak("parameter does not have magic");
    MAGIC *mg = mg_find(tsv,'P');
    if (!mg)
	croak("parameter does not have right kind of magic");
    sv = mg->mg_obj;
    if (!sv_isobject(sv))
	croak("parameter does not have really right kind of magic");
    return SvIV((SV*)SvRV(sv));
}
