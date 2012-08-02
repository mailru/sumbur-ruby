#include "ruby.h"

#define L 0xFFFFFFFF
static VALUE
rb_sumbur(VALUE self, VALUE hashed_int, VALUE capacity)
{
    unsigned int h = NUM2UINT(hashed_int);
    unsigned int capa = NUM2UINT(capacity);
    unsigned int part, n, i, c;

    if (capacity == 0) {
        rb_raise(rb_eArgError, "Sumbur is not applicable to empty cluster");
    }

    part = L / capa;

    if (L - h <= part) return INT2FIX(0);

    n = 1;

    for(i = 2; i <= capa; i++) {
        c = L / (i * (i - 1));
        if (c <= h) {
            h -= c;
        }
        else {
            h += c * (i - n - 1);
            n = i;
            if (L / i - h < part) break;
        }
    }

    return INT2FIX(n - 1);
}

void
Init_native_sumbur()
{
    VALUE mod_sumbur = rb_define_module("Sumbur");
    VALUE mod_native = rb_define_module_under(mod_sumbur, "Native");

    rb_define_method(mod_native, "sumbur", rb_sumbur, 2);
    rb_extend_object(mod_native, mod_native);
}
