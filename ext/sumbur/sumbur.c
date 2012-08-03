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

    do {
        if (h >= L / 2) h -= L / 2;
        else {
            n = 2;
            if (L / 2 - h < part) break;
        }
        if (capa == 2) break;

#define curslice(i) (L / (i * (i - 1)))
#define unroll(i) \
        if (curslice(i) <= h) h -= curslice(i); \
        else {                                  \
            h += curslice(i) * (i - n - 1);     \
            n = i;                              \
            if (L / i - h < part) break;        \
        }                                       \
        if (capa == i) break

        unroll(3); unroll(4); unroll(5); unroll(6); unroll(7);
        unroll(8); unroll(9); unroll(10); unroll(11); unroll(12);
        unroll(13); unroll(14); unroll(15); unroll(16); unroll(17);
        unroll(18); unroll(19); unroll(20); unroll(21); unroll(22);
        unroll(23); unroll(24);

        for(i = 25; i <= capa; i++) {
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
    } while(0);
    return INT2FIX(n - 1);
}

void
Init_native_sumbur()
{
    VALUE mod_sumbur = rb_define_module("Sumbur");
    VALUE mod_native = rb_define_module_under(mod_sumbur, "NativeSumbur");

    rb_define_method(mod_native, "sumbur", rb_sumbur, 2);
    rb_extend_object(mod_native, mod_native);
}
