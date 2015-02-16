#include <ral2/ral.h>

ral_object_t *perl_variable_to_ral_object(SV *sv, ral_class class);
SV *ral_object_to_perl_variable(ral_object_t *obj, int del);
