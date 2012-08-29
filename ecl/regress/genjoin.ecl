/*##############################################################################

    HPCC SYSTEMS software Copyright (C) 2012 HPCC Systems.

    This program is free software: you can redistribute it and/or modify
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
############################################################################## */

// IMPORTANT: this test is generated by the perl script genjointest.pl, so do not edit it by hand

#option('convertJoinToLookup', 0);
#option('noAllToLookupConversion', 1);
#option('spanMultipleCpp', 1);

jrec := RECORD,MAXLENGTH(100)
    UNSIGNED1 i;
    STRING3 lstr;
    STRING3 rstr;
    UNSIGNED1 c;
    STRING label;
END;

lhs := SORTED(DATASET([{3, 'aaa', '', 0, ''}, {4, 'bbb', '', 0, ''}, {5, 'ccc', '', 0, ''}, {6, 'ddd', '', 0, ''}, {7, 'eee', '', 0, ''}], jrec), i);
rhs := SORTED(DATASET([{1, '', 'fff', 0, ''}, {3, '', 'ggg', 0, ''}, {5, '', 'hhh', 0, ''}, {5, '', 'iii', 0, ''}, {5, '', 'xxx', 0, ''}, {5, '', 'jjj', 0, ''}, {7, '', 'kkk', 0, ''}, {9, '', 'lll', 0, ''}, {9, '', 'mmm', 0, ''}], jrec), i);

trueval := true : stored('trueval');
falseval := false : stored('falseval');
BOOLEAN match1(jrec l, jrec r) := (l.i = r.i);
BOOLEAN match2(jrec l, jrec r) := (r.rstr < 'x');
BOOLEAN match(jrec l, jrec r) := (match1(l, r) AND match2(l, r));
BOOLEAN allmatch1(jrec l, jrec r) := ((match1(l, r) AND trueval) OR falseval);
BOOLEAN allmatch(jrec l, jrec r) := (allmatch1(l, r) AND match2(l, r));

// transform for joins and non-group denormalizes, to be used with match or allmatch
jrec xfm(jrec l, jrec r, STRING lab) := TRANSFORM
    SELF.i := l.i;
    SELF.lstr := l.lstr;
    SELF.rstr := r.rstr;
    SELF.c := l.c+1;
    SELF.label := lab;
END;

// skipping transform for joins and non-group denormalizes
// when used with match1 or allmatch1, similar to the above, but remember that right outer picks up rows whose matches failed but not ones whose transforms skipped
jrec xfmskip(jrec l, jrec r, STRING lab) := TRANSFORM
    SELF.i := l.i;
    SELF.lstr := l.lstr;
    SELF.rstr := IF(r.rstr >= 'x', SKIP, r.rstr);
    SELF.c := l.c+1;
    SELF.label := lab;
END;

// transform for group denormalizes, to be used with match or allmatch
jrec xfmgrp(jrec l, DATASET(jrec) r, STRING lab) := TRANSFORM
    UNSIGNED c := COUNT(r);
    SELF.i := l.i;
    SELF.lstr := l.lstr;
    SELF.rstr := r[c].rstr;
    SELF.c := c;
    SELF.label := lab;
END;

// skipping transform for group denormalizes, to be used with match or allmatch
// used with match1 or allmatch1, but has a different behaviour because a skip on a group denormalize skips the whole group rather than just one row
jrec xfmgrpskip(jrec l, DATASET(jrec) r, STRING lab) := TRANSFORM
    UNSIGNED c := COUNT(r);
    UNSIGNED skp := COUNT(r(rstr >= 'x'));
    SELF.i := l.i;
    SELF.lstr := l.lstr;
    SELF.rstr := IF(skp > 0, SKIP, r[c].rstr);
    SELF.c := c;
    SELF.label := lab;
END;

join____INN________ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN'), INNER);
join____INN____xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_XFMSKIP'), INNER);
join____INN_kp_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_KEEP'), INNER, KEEP(2));
join____INN_kp_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_KEEP_XFMSKIP'), INNER, KEEP(2));
join____INN_at_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_ATMOST'), INNER, ATMOST(match1(LEFT, RIGHT), 3));
join____INN_at_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_ATMOST_XFMSKIP'), INNER, ATMOST(match1(LEFT, RIGHT), 3));
join____INN_ls_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LIMITSKIP'), INNER, LIMIT(3, SKIP), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_LIMITSKIP')));
join____INN_ls_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LIMITSKIP_XFMSKIP'), INNER, LIMIT(3, SKIP), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_LIMITSKIP_XFMSKIP')));
join____INN_lo_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LIMITONFAIL'), INNER, LIMIT(3), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_LIMITONFAIL')));
join____INN_lo_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LIMITONFAIL_XFMSKIP'), INNER, LIMIT(3), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_LIMITONFAIL_XFMSKIP')));
join____INN_lf_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LIMITFAIL'), INNER, LIMIT(3));
join____INN_lf_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LIMITFAIL_XFMSKIP'), INNER, LIMIT(3));
join____LOU________ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LEFT_OUTER'), LEFT OUTER);
join____LOU____xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LEFT_OUTER_XFMSKIP'), LEFT OUTER);
join____LOU_kp_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LEFT_OUTER_KEEP'), LEFT OUTER, KEEP(2));
join____LOU_kp_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LEFT_OUTER_KEEP_XFMSKIP'), LEFT OUTER, KEEP(2));
join____LOU_at_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LEFT_OUTER_ATMOST'), LEFT OUTER, ATMOST(match1(LEFT, RIGHT), 3));
join____LOU_at_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LEFT_OUTER_ATMOST_XFMSKIP'), LEFT OUTER, ATMOST(match1(LEFT, RIGHT), 3));
join____LOU_ls_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LEFT_OUTER_LIMITSKIP'), LEFT OUTER, LIMIT(3, SKIP), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_LEFT_OUTER_LIMITSKIP')));
join____LOU_ls_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LEFT_OUTER_LIMITSKIP_XFMSKIP'), LEFT OUTER, LIMIT(3, SKIP), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_LEFT_OUTER_LIMITSKIP_XFMSKIP')));
join____LOU_lo_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LEFT_OUTER_LIMITONFAIL'), LEFT OUTER, LIMIT(3), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_LEFT_OUTER_LIMITONFAIL')));
join____LOU_lo_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LEFT_OUTER_LIMITONFAIL_XFMSKIP'), LEFT OUTER, LIMIT(3), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_LEFT_OUTER_LIMITONFAIL_XFMSKIP')));
join____LOU_lf_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LEFT_OUTER_LIMITFAIL'), LEFT OUTER, LIMIT(3));
join____LOU_lf_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LEFT_OUTER_LIMITFAIL_XFMSKIP'), LEFT OUTER, LIMIT(3));
join____LON________ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LEFT_ONLY'), LEFT ONLY);
join____LON____xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LEFT_ONLY_XFMSKIP'), LEFT ONLY);
join____LON_at_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LEFT_ONLY_ATMOST'), LEFT ONLY, ATMOST(match1(LEFT, RIGHT), 3));
join____LON_at_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LEFT_ONLY_ATMOST_XFMSKIP'), LEFT ONLY, ATMOST(match1(LEFT, RIGHT), 3));
join____ROU________ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_RIGHT_OUTER'), RIGHT OUTER);
join____ROU____xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_RIGHT_OUTER_XFMSKIP'), RIGHT OUTER);
join____ROU_ls_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_RIGHT_OUTER_LIMITSKIP'), RIGHT OUTER, LIMIT(3, SKIP), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_RIGHT_OUTER_LIMITSKIP')));
join____ROU_ls_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_RIGHT_OUTER_LIMITSKIP_XFMSKIP'), RIGHT OUTER, LIMIT(3, SKIP), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_RIGHT_OUTER_LIMITSKIP_XFMSKIP')));
join____ROU_lo_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_RIGHT_OUTER_LIMITONFAIL'), RIGHT OUTER, LIMIT(3), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_RIGHT_OUTER_LIMITONFAIL')));
join____ROU_lo_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_RIGHT_OUTER_LIMITONFAIL_XFMSKIP'), RIGHT OUTER, LIMIT(3), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_RIGHT_OUTER_LIMITONFAIL_XFMSKIP')));
join____ROU_lf_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_RIGHT_OUTER_LIMITFAIL'), RIGHT OUTER, LIMIT(3));
join____ROU_lf_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_RIGHT_OUTER_LIMITFAIL_XFMSKIP'), RIGHT OUTER, LIMIT(3));
join____RON________ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_RIGHT_ONLY'), RIGHT ONLY);
join____RON____xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_RIGHT_ONLY_XFMSKIP'), RIGHT ONLY);
join____FOU________ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_FULL_OUTER'), FULL OUTER);
join____FOU____xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_FULL_OUTER_XFMSKIP'), FULL OUTER);
join____FOU_ls_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_FULL_OUTER_LIMITSKIP'), FULL OUTER, LIMIT(3, SKIP), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_FULL_OUTER_LIMITSKIP')));
join____FOU_ls_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_FULL_OUTER_LIMITSKIP_XFMSKIP'), FULL OUTER, LIMIT(3, SKIP), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_FULL_OUTER_LIMITSKIP_XFMSKIP')));
join____FOU_lo_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_FULL_OUTER_LIMITONFAIL'), FULL OUTER, LIMIT(3), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_FULL_OUTER_LIMITONFAIL')));
join____FOU_lo_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_FULL_OUTER_LIMITONFAIL_XFMSKIP'), FULL OUTER, LIMIT(3), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_FULL_OUTER_LIMITONFAIL_XFMSKIP')));
join____FOU_lf_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_FULL_OUTER_LIMITFAIL'), FULL OUTER, LIMIT(3));
join____FOU_lf_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_FULL_OUTER_LIMITFAIL_XFMSKIP'), FULL OUTER, LIMIT(3));
join____FON________ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_FULL_ONLY'), FULL ONLY);
join____FON____xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_FULL_ONLY_XFMSKIP'), FULL ONLY);
join_l1_INN________ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LOOKUP'), LOOKUP, INNER);
join_l1_INN____xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LOOKUP_XFMSKIP'), LOOKUP, INNER);
join_l1_LOU________ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LOOKUP_LEFT_OUTER'), LOOKUP, LEFT OUTER);
join_l1_LOU____xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LOOKUP_LEFT_OUTER_XFMSKIP'), LOOKUP, LEFT OUTER);
join_l1_LON________ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LOOKUP_LEFT_ONLY'), LOOKUP, LEFT ONLY);
join_l1_LON____xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LOOKUP_LEFT_ONLY_XFMSKIP'), LOOKUP, LEFT ONLY);
join_lm_INN________ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LOOKUP_MANY'), LOOKUP, MANY, INNER);
join_lm_INN____xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_XFMSKIP'), LOOKUP, MANY, INNER);
join_lm_INN_kp_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_KEEP'), LOOKUP, MANY, INNER, KEEP(2));
join_lm_INN_kp_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_KEEP_XFMSKIP'), LOOKUP, MANY, INNER, KEEP(2));
join_lm_INN_at_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_ATMOST'), LOOKUP, MANY, INNER, ATMOST(match1(LEFT, RIGHT), 3));
join_lm_INN_at_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_ATMOST_XFMSKIP'), LOOKUP, MANY, INNER, ATMOST(match1(LEFT, RIGHT), 3));
join_lm_INN_ls_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LIMITSKIP'), LOOKUP, MANY, INNER, LIMIT(3, SKIP), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_LOOKUP_MANY_LIMITSKIP')));
join_lm_INN_ls_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LIMITSKIP_XFMSKIP'), LOOKUP, MANY, INNER, LIMIT(3, SKIP), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_LOOKUP_MANY_LIMITSKIP_XFMSKIP')));
join_lm_INN_lo_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LIMITONFAIL'), LOOKUP, MANY, INNER, LIMIT(3), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_LOOKUP_MANY_LIMITONFAIL')));
join_lm_INN_lo_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LIMITONFAIL_XFMSKIP'), LOOKUP, MANY, INNER, LIMIT(3), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_LOOKUP_MANY_LIMITONFAIL_XFMSKIP')));
join_lm_INN_lf_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LIMITFAIL'), LOOKUP, MANY, INNER, LIMIT(3));
join_lm_INN_lf_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LIMITFAIL_XFMSKIP'), LOOKUP, MANY, INNER, LIMIT(3));
join_lm_LOU________ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LEFT_OUTER'), LOOKUP, MANY, LEFT OUTER);
join_lm_LOU____xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LEFT_OUTER_XFMSKIP'), LOOKUP, MANY, LEFT OUTER);
join_lm_LOU_kp_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LEFT_OUTER_KEEP'), LOOKUP, MANY, LEFT OUTER, KEEP(2));
join_lm_LOU_kp_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LEFT_OUTER_KEEP_XFMSKIP'), LOOKUP, MANY, LEFT OUTER, KEEP(2));
join_lm_LOU_at_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LEFT_OUTER_ATMOST'), LOOKUP, MANY, LEFT OUTER, ATMOST(match1(LEFT, RIGHT), 3));
join_lm_LOU_at_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LEFT_OUTER_ATMOST_XFMSKIP'), LOOKUP, MANY, LEFT OUTER, ATMOST(match1(LEFT, RIGHT), 3));
join_lm_LOU_ls_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LEFT_OUTER_LIMITSKIP'), LOOKUP, MANY, LEFT OUTER, LIMIT(3, SKIP), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_LOOKUP_MANY_LEFT_OUTER_LIMITSKIP')));
join_lm_LOU_ls_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LEFT_OUTER_LIMITSKIP_XFMSKIP'), LOOKUP, MANY, LEFT OUTER, LIMIT(3, SKIP), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_LOOKUP_MANY_LEFT_OUTER_LIMITSKIP_XFMSKIP')));
join_lm_LOU_lo_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LEFT_OUTER_LIMITONFAIL'), LOOKUP, MANY, LEFT OUTER, LIMIT(3), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_LOOKUP_MANY_LEFT_OUTER_LIMITONFAIL')));
join_lm_LOU_lo_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LEFT_OUTER_LIMITONFAIL_XFMSKIP'), LOOKUP, MANY, LEFT OUTER, LIMIT(3), ONFAIL(xfm(LEFT, RIGHT, 'FAILED: JOIN_LOOKUP_MANY_LEFT_OUTER_LIMITONFAIL_XFMSKIP')));
join_lm_LOU_lf_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LEFT_OUTER_LIMITFAIL'), LOOKUP, MANY, LEFT OUTER, LIMIT(3));
join_lm_LOU_lf_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LEFT_OUTER_LIMITFAIL_XFMSKIP'), LOOKUP, MANY, LEFT OUTER, LIMIT(3));
join_lm_LON________ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LEFT_ONLY'), LOOKUP, MANY, LEFT ONLY);
join_lm_LON____xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LEFT_ONLY_XFMSKIP'), LOOKUP, MANY, LEFT ONLY);
join_lm_LON_at_____ := JOIN(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LEFT_ONLY_ATMOST'), LOOKUP, MANY, LEFT ONLY, ATMOST(match1(LEFT, RIGHT), 3));
join_lm_LON_at_xs__ := JOIN(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_LOOKUP_MANY_LEFT_ONLY_ATMOST_XFMSKIP'), LOOKUP, MANY, LEFT ONLY, ATMOST(match1(LEFT, RIGHT), 3));
join_al_INN________ := JOIN(lhs, rhs, allmatch(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_ALL'), ALL, INNER);
join_al_INN____xs__ := JOIN(lhs, rhs, allmatch1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_ALL_XFMSKIP'), ALL, INNER);
join_al_INN_kp_____ := JOIN(lhs, rhs, allmatch(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_ALL_KEEP'), ALL, INNER, KEEP(2));
join_al_INN_kp_xs__ := JOIN(lhs, rhs, allmatch1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_ALL_KEEP_XFMSKIP'), ALL, INNER, KEEP(2));
join_al_LOU________ := JOIN(lhs, rhs, allmatch(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_ALL_LEFT_OUTER'), ALL, LEFT OUTER);
join_al_LOU____xs__ := JOIN(lhs, rhs, allmatch1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_ALL_LEFT_OUTER_XFMSKIP'), ALL, LEFT OUTER);
join_al_LOU_kp_____ := JOIN(lhs, rhs, allmatch(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_ALL_LEFT_OUTER_KEEP'), ALL, LEFT OUTER, KEEP(2));
join_al_LOU_kp_xs__ := JOIN(lhs, rhs, allmatch1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_ALL_LEFT_OUTER_KEEP_XFMSKIP'), ALL, LEFT OUTER, KEEP(2));
join_al_LON________ := JOIN(lhs, rhs, allmatch(LEFT, RIGHT), xfm(LEFT, RIGHT, 'JOIN_ALL_LEFT_ONLY'), ALL, LEFT ONLY);
join_al_LON____xs__ := JOIN(lhs, rhs, allmatch1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'JOIN_ALL_LEFT_ONLY_XFMSKIP'), ALL, LEFT ONLY);
deno____LOU________ := DENORMALIZE(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'DENORMALIZE_LEFT_OUTER'), LEFT OUTER);
deno____LOU____xs__ := DENORMALIZE(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'DENORMALIZE_LEFT_OUTER_XFMSKIP'), LEFT OUTER);
deno____LOU_kp_____ := DENORMALIZE(lhs, rhs, match(LEFT, RIGHT), xfm(LEFT, RIGHT, 'DENORMALIZE_LEFT_OUTER_KEEP'), LEFT OUTER, KEEP(2));
deno____LOU_kp_xs__ := DENORMALIZE(lhs, rhs, match1(LEFT, RIGHT), xfmskip(LEFT, RIGHT, 'DENORMALIZE_LEFT_OUTER_KEEP_XFMSKIP'), LEFT OUTER, KEEP(2));

SEQUENTIAL(OUTPUT(join____INN________, NAMED('JOIN')),
           OUTPUT(join____INN____xs__, NAMED('JOIN_XFMSKIP')),
           OUTPUT(join____INN_kp_____, NAMED('JOIN_KEEP')),
           OUTPUT(join____INN_kp_xs__, NAMED('JOIN_KEEP_XFMSKIP')),
           OUTPUT(join____INN_at_____, NAMED('JOIN_ATMOST')),
           OUTPUT(join____INN_at_xs__, NAMED('JOIN_ATMOST_XFMSKIP')),
           OUTPUT(join____INN_ls_____, NAMED('JOIN_LIMITSKIP')),
           OUTPUT(join____INN_ls_xs__, NAMED('JOIN_LIMITSKIP_XFMSKIP')),
           OUTPUT(join____INN_lo_____, NAMED('JOIN_LIMITONFAIL')),
           OUTPUT(join____INN_lo_xs__, NAMED('JOIN_LIMITONFAIL_XFMSKIP')),
           OUTPUT(join____LOU________, NAMED('JOIN_LEFT_OUTER')),
           OUTPUT(join____LOU____xs__, NAMED('JOIN_LEFT_OUTER_XFMSKIP')),
           OUTPUT(join____LOU_kp_____, NAMED('JOIN_LEFT_OUTER_KEEP')),
           OUTPUT(join____LOU_kp_xs__, NAMED('JOIN_LEFT_OUTER_KEEP_XFMSKIP')),
           OUTPUT(join____LOU_at_____, NAMED('JOIN_LEFT_OUTER_ATMOST')),
           OUTPUT(join____LOU_at_xs__, NAMED('JOIN_LEFT_OUTER_ATMOST_XFMSKIP')),
           OUTPUT(join____LOU_ls_____, NAMED('JOIN_LEFT_OUTER_LIMITSKIP')),
           OUTPUT(join____LOU_ls_xs__, NAMED('JOIN_LEFT_OUTER_LIMITSKIP_XFMSKIP')),
           OUTPUT(join____LOU_lo_____, NAMED('JOIN_LEFT_OUTER_LIMITONFAIL')),
           OUTPUT(join____LOU_lo_xs__, NAMED('JOIN_LEFT_OUTER_LIMITONFAIL_XFMSKIP')),
           OUTPUT(join____LON________, NAMED('JOIN_LEFT_ONLY')),
           OUTPUT(join____LON____xs__, NAMED('JOIN_LEFT_ONLY_XFMSKIP')),
           OUTPUT(join____LON_at_____, NAMED('JOIN_LEFT_ONLY_ATMOST')),
           OUTPUT(join____LON_at_xs__, NAMED('JOIN_LEFT_ONLY_ATMOST_XFMSKIP')),
           OUTPUT(join____ROU________, NAMED('JOIN_RIGHT_OUTER')),
           OUTPUT(join____ROU____xs__, NAMED('JOIN_RIGHT_OUTER_XFMSKIP')),
           OUTPUT(join____ROU_ls_____, NAMED('JOIN_RIGHT_OUTER_LIMITSKIP')),
           OUTPUT(join____ROU_ls_xs__, NAMED('JOIN_RIGHT_OUTER_LIMITSKIP_XFMSKIP')),
           OUTPUT(join____ROU_lo_____, NAMED('JOIN_RIGHT_OUTER_LIMITONFAIL')),
           OUTPUT(join____ROU_lo_xs__, NAMED('JOIN_RIGHT_OUTER_LIMITONFAIL_XFMSKIP')),
           OUTPUT(join____RON________, NAMED('JOIN_RIGHT_ONLY')),
           OUTPUT(join____RON____xs__, NAMED('JOIN_RIGHT_ONLY_XFMSKIP')),
           OUTPUT(join____FOU________, NAMED('JOIN_FULL_OUTER')),
           OUTPUT(join____FOU____xs__, NAMED('JOIN_FULL_OUTER_XFMSKIP')),
           OUTPUT(join____FOU_ls_____, NAMED('JOIN_FULL_OUTER_LIMITSKIP')),
           OUTPUT(join____FOU_ls_xs__, NAMED('JOIN_FULL_OUTER_LIMITSKIP_XFMSKIP')),
           OUTPUT(join____FOU_lo_____, NAMED('JOIN_FULL_OUTER_LIMITONFAIL')),
           OUTPUT(join____FOU_lo_xs__, NAMED('JOIN_FULL_OUTER_LIMITONFAIL_XFMSKIP')),
           OUTPUT(join____FON________, NAMED('JOIN_FULL_ONLY')),
           OUTPUT(join____FON____xs__, NAMED('JOIN_FULL_ONLY_XFMSKIP')),
           OUTPUT(join_l1_INN________, NAMED('JOIN_LOOKUP')),
           OUTPUT(join_l1_INN____xs__, NAMED('JOIN_LOOKUP_XFMSKIP')),
           OUTPUT(join_l1_LOU________, NAMED('JOIN_LOOKUP_LEFT_OUTER')),
           OUTPUT(join_l1_LOU____xs__, NAMED('JOIN_LOOKUP_LEFT_OUTER_XFMSKIP')),
           OUTPUT(join_l1_LON________, NAMED('JOIN_LOOKUP_LEFT_ONLY')),
           OUTPUT(join_l1_LON____xs__, NAMED('JOIN_LOOKUP_LEFT_ONLY_XFMSKIP')),
           OUTPUT(join_lm_INN________, NAMED('JOIN_LOOKUP_MANY')),
           OUTPUT(join_lm_INN____xs__, NAMED('JOIN_LOOKUP_MANY_XFMSKIP')),
           OUTPUT(join_lm_INN_kp_____, NAMED('JOIN_LOOKUP_MANY_KEEP')),
           OUTPUT(join_lm_INN_kp_xs__, NAMED('JOIN_LOOKUP_MANY_KEEP_XFMSKIP')),
           OUTPUT(join_lm_INN_at_____, NAMED('JOIN_LOOKUP_MANY_ATMOST')),
           OUTPUT(join_lm_INN_at_xs__, NAMED('JOIN_LOOKUP_MANY_ATMOST_XFMSKIP')),
           OUTPUT(join_lm_INN_ls_____, NAMED('JOIN_LOOKUP_MANY_LIMITSKIP')),
           OUTPUT(join_lm_INN_ls_xs__, NAMED('JOIN_LOOKUP_MANY_LIMITSKIP_XFMSKIP')),
           OUTPUT(join_lm_INN_lo_____, NAMED('JOIN_LOOKUP_MANY_LIMITONFAIL')),
           OUTPUT(join_lm_INN_lo_xs__, NAMED('JOIN_LOOKUP_MANY_LIMITONFAIL_XFMSKIP')),
           OUTPUT(join_lm_LOU________, NAMED('JOIN_LOOKUP_MANY_LEFT_OUTER')),
           OUTPUT(join_lm_LOU____xs__, NAMED('JOIN_LOOKUP_MANY_LEFT_OUTER_XFMSKIP')),
           OUTPUT(join_lm_LOU_kp_____, NAMED('JOIN_LOOKUP_MANY_LEFT_OUTER_KEEP')),
           OUTPUT(join_lm_LOU_kp_xs__, NAMED('JOIN_LOOKUP_MANY_LEFT_OUTER_KEEP_XFMSKIP')),
           OUTPUT(join_lm_LOU_at_____, NAMED('JOIN_LOOKUP_MANY_LEFT_OUTER_ATMOST')),
           OUTPUT(join_lm_LOU_at_xs__, NAMED('JOIN_LOOKUP_MANY_LEFT_OUTER_ATMOST_XFMSKIP')),
           OUTPUT(join_lm_LOU_ls_____, NAMED('JOIN_LOOKUP_MANY_LEFT_OUTER_LIMITSKIP')),
           OUTPUT(join_lm_LOU_ls_xs__, NAMED('JOIN_LOOKUP_MANY_LEFT_OUTER_LIMITSKIP_XFMSKIP')),
           OUTPUT(join_lm_LOU_lo_____, NAMED('JOIN_LOOKUP_MANY_LEFT_OUTER_LIMITONFAIL')),
           OUTPUT(join_lm_LOU_lo_xs__, NAMED('JOIN_LOOKUP_MANY_LEFT_OUTER_LIMITONFAIL_XFMSKIP')),
           OUTPUT(join_lm_LON________, NAMED('JOIN_LOOKUP_MANY_LEFT_ONLY')),
           OUTPUT(join_lm_LON____xs__, NAMED('JOIN_LOOKUP_MANY_LEFT_ONLY_XFMSKIP')),
           OUTPUT(join_lm_LON_at_____, NAMED('JOIN_LOOKUP_MANY_LEFT_ONLY_ATMOST')),
           OUTPUT(join_lm_LON_at_xs__, NAMED('JOIN_LOOKUP_MANY_LEFT_ONLY_ATMOST_XFMSKIP')),
           OUTPUT(join_al_INN________, NAMED('JOIN_ALL')),
           OUTPUT(join_al_INN____xs__, NAMED('JOIN_ALL_XFMSKIP')),
           OUTPUT(join_al_INN_kp_____, NAMED('JOIN_ALL_KEEP')),
           OUTPUT(join_al_INN_kp_xs__, NAMED('JOIN_ALL_KEEP_XFMSKIP')),
           OUTPUT(join_al_LOU________, NAMED('JOIN_ALL_LEFT_OUTER')),
           OUTPUT(join_al_LOU____xs__, NAMED('JOIN_ALL_LEFT_OUTER_XFMSKIP')),
           OUTPUT(join_al_LOU_kp_____, NAMED('JOIN_ALL_LEFT_OUTER_KEEP')),
           OUTPUT(join_al_LOU_kp_xs__, NAMED('JOIN_ALL_LEFT_OUTER_KEEP_XFMSKIP')),
           OUTPUT(join_al_LON________, NAMED('JOIN_ALL_LEFT_ONLY')),
           OUTPUT(join_al_LON____xs__, NAMED('JOIN_ALL_LEFT_ONLY_XFMSKIP')),
           OUTPUT(deno____LOU________, NAMED('DENORMALIZE_LEFT_OUTER')),
           OUTPUT(deno____LOU____xs__, NAMED('DENORMALIZE_LEFT_OUTER_XFMSKIP')),
           OUTPUT(deno____LOU_kp_____, NAMED('DENORMALIZE_LEFT_OUTER_KEEP')),
           OUTPUT(deno____LOU_kp_xs__, NAMED('DENORMALIZE_LEFT_OUTER_KEEP_XFMSKIP')));
