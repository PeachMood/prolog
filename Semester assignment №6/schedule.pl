% To get the schedule, it is necessary to call the command swipl 20214-VoronovaAS-A6.pl on the command line and call the predicate make_schedule/0.

:- use_module(small_data).
%:- use_module(large_data).
:- use_module(utils).
:- use_module(cost).

% accommodates_students(+Exam)
%   +Exam: event/4 functor representing a new exam added to the schedule
% Checks if the room can accommodate all students taking the exam. If yes, accommodates_students/1 is asserted.
accommodates_students(event(Exam, Room, _, _)) :-
    classroom_capacity(Room, Capacity),
    st_group(Exam, Students),
    length(Students, StudentsNumber),
    StudentsNumber =< Capacity.

% same_time(+Exam1, +From1, +Exam2, +From2)
%   +Exam1: ID of a new exam added to the schedule
%   +From1: start of a new exam
%   +Exam2: ID of an exam added from the schedule
%   +From2: start of an exam added from the schedule
% Checks if the specified exams are held at the same time of day. If yes, same_time/4 is asserted.
same_time(Exam1, From1, Exam2, From2):-
    exam_duration(Exam1, Duration1),
    Till1 is From1 + Duration1,
    exam_duration(Exam2, Duration2),
    Till2 is From2 + Duration2,
    ((From2 >= From1, From2 =< Till1);
    (From1 >= From2, From1 =< Till2)).

% same_room_and_time(+Exam1, +Exam2)
%   +Exam1: event/4 functor representing a new exam added to the schedule
%   +Exam2: event/4 functor representing an exam from the schedule
% Checks if the specified exams are taking place in the same classroom and at the same time. If yes, same_room_and_time/2 is asserted.
same_room_and_time(event(Exam1, Room, Day, From1), event(Exam2, Room, Day, From2)) :-
    same_time(Exam1, From1, Exam2, From2).

% same_student(+Exam1, +Exam2)
%   +Exam1: event/4 functor representing a new exam added to the schedule
%   +Exam2: event/4 functor representing an exam from the schedule
% Сhecks if any student will have to take two exams at the same time. If yes, same_student/2 is asserted.
same_student(event(Exam1, _, Day, From1), event(Exam2, _, Day, From2)) :-
    student_follows_both_classes(Exam1, Exam2),
    same_time(Exam1, From1, Exam2, From2).

% same_teacher(+Exam1, +Exam2)
%   +Exam1: event/4 functor representing a new exam added to the schedule
%   +Exam2: event/4 functor representing an exam from the schedule
% Сhecks if a teacher has to take two exams at the same time. If yes, same_teacher/2 is asserted.
same_teacher(event(Exam1, _, Day, From1), event(Exam2, _, Day, From2)) :-
    teacher_teaches_both_classes(Exam1, Exam2),
    same_time(Exam1, From1, Exam2, From2).

% exam_loop(+Exam, +Exams)
%   +Exam: event/4 functor representing a new exam added to the schedule
%   +Exams: a list of event/4 functors representing the schedule
% Goes through the list of exams already added to the schedule and checks if the new exam violates any of the mandatory restrictions. If yes, exam_loop/2 is asserted.
exam_loop(Exam1, [Exam2| _]) :-
    \+accommodates_students(Exam1);
    same_room_and_time(Exam1, Exam2);
    same_student(Exam1, Exam2);
    same_teacher(Exam1, Exam2).
exam_loop(Exam1, [_ | OtherExams]) :-
    exam_loop(Exam1, OtherExams).

% violates_mandatory_constraint(+Schedule)
%   +Schedule: functor node(State, Length, H) representing the schedule
% Checks if the new schedule violates any of the mandatory constraints. If yes, violates_mandatory_constraint/1 is asserted.
violates_mandatory_constraint(node([event(Exam, Room, Day, From) | Schedule], _, _)) :-
    exam_loop(event(Exam, Room, Day, From), Schedule).

% neighbor(+Schedule, -NewSchedule)
%   +Schedule: functor node(Schedule, Length, Priority) representing the old schedule
%   -NewSchedule: functor node(NewSchedule, NewLength, NewPriority) representing the new schedule with added exam
% According to a given schedule of length N, constructs all possible schedules of length N + 1 and calculates
% the priority for them (the cost of the schedule minus the value of the heuristic function)
neighbor(node(Schedule, Length, _), node(NewSchedule, NewLength, NewPriority)) :-
    exam(Exam, _),
    not(member(event(Exam, _, _, _), Schedule)),
    classroom_available(Room, Day, From, Till),
    exam_duration(Exam, Duration), To is Till - Duration,
    between(From, To, Start),
    NewSchedule = [event(Exam, Room, Day, Start) | Schedule],
    NewLength is Length + 1,
    cost(schedule(NewSchedule), Cost),
    NewPriority is Cost - NewLength.

% print_exams(+Exams)
%   +Exams: a list of event/4 functors representing exams
% Prints all exams from the specified list. Displays exam time, classroom number and subject name
print_exams([]).
print_exams([event(EID, RID, _, From) | Exams]) :-
    exam_duration(EID, Duration),
    Till is From + Duration,
    format("Time: from ~w:00 till ~w:00\n", [From, Till]),
    format("Audience number: ~w\n", [RID]),
    exam(EID, Subject),
    format("Subject: ~w\n", [Subject]),
    teaches(PID, EID),
    teacher(PID, Teacher),
    format("Teacher: ~w\n", [Teacher]), nl,
    print_exams(Exams).

% print_days(+Days, +Exams)
%   +Days: a list of days
%   +Exams: a list of event/4 functors representing exams
% Finds all exams that will take place on the days listed in the +Days list and displays them in the order in which they took place
print_days([], _).
print_days([Day | Days], Exams) :-
    findall(event(Exam, Room, Day, From), member(event(Exam, Room, Day, From), Exams), List),
    \+length(List, 0), !,
    format("Day: ~w\n", [Day]),
    writeln("====================================="),
    sort(4, =<, List, Sorted),
    print_exams(Sorted),
    print_days(Days, Exams).
print_days([_ | Days], Exams) :-
    print_days(Days, Exams).

% print_cost(+Exams)
%   +Exams: a list of event/4 functors representing exams
% Prints the cost of the specified schedule.
print_cost(Exams) :-
    cost(schedule(Exams), Cost),
    format("Total cost: ~w\n", [Cost]),
    writeln("-------------------------------------").

% print_schedule(+Exams)
%   +Exams: a list of event/4 functors representing exams
% Prints the specified schedule
print_schedule(Exams) :-
    writeln("---------------SHEDULE---------------"),
    findall(Day, (ex_season_starts(Start), ex_season_ends(End), between(Start, End, Day)), Days),
    print_days(Days, Exams),
    print_cost(Exams).

% update_frontier(+NewNodes, +Frontier, -NewFrontier)
%   +NewNodes: a list of new nodes to be added to the frontier
%   +Frontier: sorted queue of nodes, remaining in the frontier
%   -NewFrontier: a new list of nodes with added vertices and saved order
% Adds new vertices to the frontier
update_frontier(NewNodes, Frontier, NewFrontier) :-
    append(NewNodes, Frontier, Nodes),
    sort(3, =<, Nodes, NewFrontier).

% dijkstra_search(+Frontier, +Goal)
%   +Frontier: a sorted queue of nodes, remaining in the frontier
%   +Goal: the number of all exams to be included in the schedule
% Predicate performs the main loop of the dijkstra search algorithm.
% Early exit: if next node in a queue is a Goal then we reached it, and have no need to proceed further.
dijkstra_search([node(Schedule, Goal, _)| _], Goal) :-
    !, print_schedule(Schedule).
dijkstra_search([Node | Frontier], Goal) :-
    findall(Neighbor, (neighbor(Node, Neighbor), \+violates_mandatory_constraint(Neighbor)), Neighbors),
    update_frontier(Neighbors, Frontier, NewFrontier),
    dijkstra_search(NewFrontier, Goal).

% make_schedule
% Draws up a schedule of exams with the least amount of penalties and displays it in a convenient form
make_schedule :-
    findall(Exam, class_has_exam(Exam), Exams),
    prepare_env(Exams),
    length(Exams, Length),
    dijkstra_search([node([], 0, 0)], Length),
    clean.
