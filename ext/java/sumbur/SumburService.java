package sumbur;

import org.jruby.Ruby;
import org.jruby.RubyFixnum;
import org.jruby.RubyModule;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.builtin.IRubyObject;
import org.jruby.runtime.load.BasicLibraryService;
import org.jruby.anno.JRubyMethod;

public class SumburService implements BasicLibraryService {
    public boolean basicLoad(Ruby ruby) {
        RubyModule sumbur = ruby.defineModule("Sumbur");
        RubyModule javas = sumbur.defineModuleUnder("Java");
        javas.defineAnnotatedMethod(SumburService.class, "sumbur");
        javas.extend_object(javas);
        return true;
    }

    static final long L = 0xFFFFFFFFL;
    static final long L2 = L / 2;
    static final long L3 = L / 3;
    static final long L4 = L / 4;
    static final long L5 = L / 5;
    static final long L6 = L / 6;
    static final long L7 = L / 7;
    static final long L8 = L / 8;
    static final long L12 = L / 12;
    static final long L20 = L / 20;
    static final long L30 = L / 30;
    static final long L42 = L / 42;
    static final long L56 = L / 56;
    static final long[] L9_62 = {L / 9, L / 10, L / 11, L / 12, L / 13, L / 14,
                                 L / 15, L / 16, L / 17, L / 18, L / 19, L / 20,
                                 L / 21, L / 22, L / 23, L / 24, L / 25, L / 26,
                                 L / 27, L / 28, L / 29, L / 30, L / 31, L / 32,
                                 L / 33, L / 34, L / 35, L / 36, L / 37, L / 38,
                                 L / 39, L / 40, L / 41, L / 42, L / 43, L / 44,
                                 L / 45, L / 46, L / 47, L / 48, L / 49, L / 50,
                                 L / 51, L / 52, L / 53, L / 54, L / 55, L / 56,
                                 L / 57, L / 58, L / 59, L / 60, L / 61, L / 62
                                 };
    static final long[] LL9_62 = {L/(8*9), L/(9*10), L/(10*11), L/(11*12), L/(12*13), L/(13*14),
                                  L/(14*15), L/(15*16), L/(16*17), L/(17*18), L/(18*19), L/(19*20),
                                  L/(20*21), L/(21*22), L/(22*23), L/(23*24), L/(24*25), L/(25*26),
                                  L/(26*27), L/(27*28), L/(28*29), L/(29*30), L/(30*31), L/(31*32),
                                  L/(32*33), L/(33*34), L/(34*35), L/(35*36), L/(36*37), L/(37*38),
                                  L/(38*39), L/(39*40), L/(40*41), L/(41*42), L/(42*43), L/(43*44),
                                  L/(44*45), L/(45*46), L/(46*47), L/(47*48), L/(48*49), L/(49*50),
                                  L/(50*51), L/(51*52), L/(52*53), L/(53*54), L/(54*55), L/(55*56),
                                  L/(56*57), L/(57*58), L/(58*59), L/(59*60), L/(60*61), L/(61*62)
                                 };

    @JRubyMethod
    public static IRubyObject sumbur(ThreadContext context, IRubyObject self, IRubyObject hashed, IRubyObject capacity)
    {
        long h = RubyFixnum.fix2long(hashed) & L;
        long capa = RubyFixnum.fix2long(capacity);

        if (capa == 0) {
            throw context.runtime.newArgumentError("Sumbur is not applicable to empty cluster");
        }

        long part = L / capa;
        if (L - h < part) return RubyFixnum.zero(context.runtime);

        long c;
        int n = 1, i;

        do {
            if (h >= L2) h -= L2;
            else {
                n = 2;
                if (L2 - h < part) break;
            }
            if (capa == 2) break;

            if (h >= L6) h -= L6;
            else {
                h += L6 * (2 - n);
                n = 3;
                if (L3 - h < part) break;
            }
            if (capa == 3) break;

            if (h >= L12) h -= L12;
            else {
                h += L12 * (3 - n);
                n = 4;
                if (L4 - h < part) break;
            }
            if (capa == 4) break;

            if (h >= L20) h -= L20;
            else {
                h += L20 * (4 - n);
                n = 5;
                if (L5 - h < part) break;
            }
            if (capa == 5) break;

            if (h >= L30) h -= L30;
            else {
                h += L30 * (5 - n);
                n = 6;
                if (L6 - h < part) break;
            }
            if (capa == 6) break;

            if (h >= L42) h -= L42;
            else {
                h += L42 * (6 - n);
                n = 7;
                if (L7 - h < part) break;
            }
            if (capa == 7) break;

            if (h >= L56) h -= L56;
            else {
                h += L56 * (7 - n);
                n = 8;
                if (L8 - h < part) break;
            }
            if (capa == 8) break;

            for (i = 9; i <= capa && i <= 62; i++) {
                c = LL9_62[i-9];
                if (c <= h) {
                    h -= c;
                }
                else {
                    h += c * (i - n - 1);
                    n = i;
                    if (L9_62[i-9] - h < part) break;
                }
            }

            for (i = 63; i <= capa; i++) {
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
        } while (false);
        return RubyFixnum.newFixnum(context.runtime, n - 1);
    }
}
