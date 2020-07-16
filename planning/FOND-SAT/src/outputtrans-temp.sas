begin_version
3
end_version
begin_metric
0
end_metric
4
begin_variable
var0
-1
4
Atom position(p0)
Atom position(p1)
Atom position(p2)
Atom position(p3)
end_variable
begin_variable
var1
-1
3
Atom q1(p3)
Atom q2(p3)
Atom q3(p3)
end_variable
begin_variable
var2
-1
2
Atom turndomain()
NegatedAtom turndomain()
end_variable
begin_variable
var3
-1
2
Atom up()
NegatedAtom up()
end_variable
5
begin_mutex_group
4
0 0
0 1
0 2
0 3
end_mutex_group
begin_mutex_group
2
1 0
1 1
end_mutex_group
begin_mutex_group
2
1 0
1 1
end_mutex_group
begin_mutex_group
3
1 0
1 1
1 2
end_mutex_group
begin_mutex_group
3
1 0
1 1
1 2
end_mutex_group
begin_state
0
0
0
1
end_state
begin_goal
2
1 2
2 0
end_goal
21
begin_operator
climb p0
1
0 0
2
0 2 0 1
0 3 1 0
0
end_operator
begin_operator
trans-01_v1 p3
1
0 0
2
0 1 0 1
0 2 1 0
0
end_operator
begin_operator
trans-01_v2 p3
1
0 1
2
0 1 0 1
0 2 1 0
0
end_operator
begin_operator
trans-01_v3 p3
1
0 2
2
0 1 0 1
0 2 1 0
0
end_operator
begin_operator
trans-02 p3
2
0 3
3 1
2
0 1 0 1
0 2 1 0
0
end_operator
begin_operator
trans-03_v1 p3
2
0 0
1 1
1
0 2 1 0
0
end_operator
begin_operator
trans-03_v2 p3
2
0 1
1 1
1
0 2 1 0
0
end_operator
begin_operator
trans-03_v3 p3
2
0 2
1 1
1
0 2 1 0
0
end_operator
begin_operator
trans-04 p3
3
0 3
1 1
3 1
1
0 2 1 0
0
end_operator
begin_operator
trans-11 p3
2
0 3
3 0
2
0 1 0 2
0 2 1 0
0
end_operator
begin_operator
trans-12 p3
2
0 3
3 0
2
0 1 1 2
0 2 1 0
0
end_operator
begin_operator
trans-13 p3
1
1 2
1
0 2 1 0
0
end_operator
begin_operator
walk p1 p0
1
3 1
2
0 0 1 0
0 2 0 1
0
end_operator
begin_operator
walk p2 p1
1
3 1
2
0 0 2 1
0 2 0 1
0
end_operator
begin_operator
walk p3 p2
1
3 1
2
0 0 3 2
0 2 0 1
0
end_operator
begin_operator
walk-on-beam_DETDUP_0 p0 p1
1
3 0
2
0 0 0 1
0 2 0 1
0
end_operator
begin_operator
walk-on-beam_DETDUP_0 p1 p2
1
3 0
2
0 0 1 2
0 2 0 1
0
end_operator
begin_operator
walk-on-beam_DETDUP_0 p2 p3
1
3 0
2
0 0 2 3
0 2 0 1
0
end_operator
begin_operator
walk-on-beam_DETDUP_1 p0 p1
0
3
0 0 0 1
0 2 0 1
0 3 0 1
0
end_operator
begin_operator
walk-on-beam_DETDUP_1 p1 p2
0
3
0 0 1 2
0 2 0 1
0 3 0 1
0
end_operator
begin_operator
walk-on-beam_DETDUP_1 p2 p3
0
3
0 0 2 3
0 2 0 1
0 3 0 1
0
end_operator
0
