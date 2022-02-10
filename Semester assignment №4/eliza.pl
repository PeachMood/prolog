% Для начала работы достаточно написать в консоли swipl 20214-VoronovaAS-A4.pl
% После запуска программы, Вы увидете приветствие и вопрос, на который можно ответить в любой форме

:- encoding(utf8).
:- use_module('20214-VoronovaAS-A4-mod1').
:- initialization(main, main).

main :- writeln("Приветствую Вас! Я виртуальный психотерапевт Элиза!"), 
        ask("Расскажите, как Вы себя чувствуете", Response),
        find_patterns(user, Response, Patterns), 
        discuss(Patterns).

find_patterns(Topic, Response, Patterns) :- rec(Topic, Response, Unordered), sort(Unordered, Patterns).

ask(Questinon, Response) :- write(Questinon), writeln("?"), write("|: "), 
                            read_string(current_input, "\n\r", "\n\r", _, Input), nl, 
                            string_lower(Input, LowerCase), 
                            split_string(LowerCase, ",.!?; ", "", Response).

set_feelling(5, Feelling) :- get_form(Feelling, 1, Form), assertz(feelling(Form)).
set_feelling(_, _).
get_feelling(Feelling) :- feelling(Feelling), retract(feelling(Feelling)), !.

set_person(9, Person) :- get_form(Person, 6, Form), assertz(person(Form)).
set_person(_, _).
get_person(Person) :- person(Person), retract(person(Person)), !.

rec(_, [], []).
rec(Topic, [Word | Words], Patterns) :- \+ matches_pattern(Topic, Word, _), rec(Topic, Words, Patterns).
rec(Topic, [Word | Words], [Pattern | Patterns]) :- matches_pattern(Topic, Word, Pattern), 
                                                    set_feelling(Pattern, Word),
                                                    set_person(Pattern, Word),
                                                    rec(Topic, Words, Patterns). 


answer([1]) :- writeln("Благодарю Вас за интересную беседу."),
               writeln("Выражаю искреннюю надежду на то, что смогла Вам чем-нибудь помочь."), nl, !.
answer([4]) :- writeln("К сожалению, я не обладаю квалицификацией сексолога."),
               writeln("По этой причине я не могу помочь Вам решить проблему, затрагивающую тему половых отношений."),
               writeln("Однако это очень важная тема, поэтому, пожалуйста, постарайтесь обратиться к специалисту."), nl, !.
answer([5]) :- writeln("Спасибо, что рассказали мне об этом."),
               writeln("К сожалению, мы не всегда можем управлять своими чувствами."),
               writeln("Однако стоит помнить, что все, даже самое плохое, однажды проходит"),
               writeln("Я не смогу изменить Вашу жизнь, но я могу дать Вам несколько советов, чтобы Вы смогли сделать ее лучше."),
               writeln("  1) Заботьтесь о себе"),
               writeln("  2) Сравнивайте себя с собой и меняйтесь"),
               writeln("  3) Проводите время с близкими людьми"),
               writeln("  4) Оставляйте прошлое в прошлом"),
               writeln("  5) Слушайте в первую очередь себя"),
               writeln("  6) Следите за питанием"),
               writeln("  7) Высыпайтесь"),
               writeln("  8) Тренируйте своё тело"),
               writeln("  9) Фиксируйте свой прогресс"),
               writeln(" 10) Создавайте образ желаемого будущего"), nl, !.
answer([6]) :- writeln("Пожалуйста, расскажите подробнее. Так я смогу лучше Вас понять."), nl, !.
answer([7]) :- writeln("Пожалуйста, постарайтесь отпустить ваши комплексны и фиксации."),
               writeln("Иногда мы уделяем слишком много времени незначительным вещам, забывая о главном."), nl, !.
answer([8]) :- writeln("Помните, что в жизни ничто не постоянно. Однажды \"всегда\" станет частью прошлого."), nl, !.
answer([9]) :- writeln("Все же мы не можем отрицать, что семья является важной частью жизни человека."), nl, !.
answer([10]) :- writeln("Я рада, что Вы решили сразу рассказать мне о своих чувствах."), 
                writeln("Чувства, хорошие и плохие, не стоит долго держать в себе."), nl, !.
answer([11]) :- writeln("Должно быть, держать эти чувства в себе так долго было тяжело."),
                writeln("Спасибо, что решили поделиться ими со мной."), nl, !.
answer([13, 14]) :- writeln("На некоторые вопросы бывает действительно трудно найти подходящий ответ."), 
                    writeln("Не переживайте. Давайте просто продолжим дальше."), nl, !.
answer([16]) :- writeln("Если эти чувства делают Вас несчастными, спросите себя: \"А любовь ли это?\""),
                writeln("Любовь должна приносить радость. Вы заслуживаете быть любимым и счастливым."),
                writeln("Пожалуйста, помните об этом."), nl, !.
answer([17]) :- writeln("Найти человека, который приносит Вам счастье, - это большая удача."),
                writeln("Я надеюсь, что любовь и дальше будет оставаться для Вас светлым чувством."), nl, !.
answer([15, 16]) :- answer([17]), nl, !.
answer([15, 17]) :- answer([16]), nl, !.
answer([16, 17]) :- writeln("Искренне надеюсь, что это чувство приносит вам больше положительных эмоций, чем отрицательных."), nl, !.
answer(_) :- writeln("Хорошо. Я вас поняла. Давайте продолжим.").

end_discussion(Response) :- find_patterns(end, Response, Patterns), Patterns == [1].
uncertain_response(Response) :- find_patterns(uncertainty, Response, Patterns), Patterns == [13,14].
short_response(Response) :- find_patterns(short, Response, Patterns), Patterns == [6], length(Response, Length), Length == 1.

discuss([]) :- predicate_property(feelling(_), dynamic), 
               get_feelling(Feelling), concat("Ранее вы сказали, что испытываете ", Feelling, Answer), 
               write(Answer), writeln("."), 
               ask("Не могли бы Вы рассказать о Ваших чувствах подробнее", Response), 
               (short_response(Response) *-> answer([6]), asserta(feelling(Feelling)), discuss([]);
                    find_patterns(user, Response, Patterns), discuss(Patterns)).
discuss([]) :- predicate_property(person(_), dynamic),
               get_person(Person), concat("Ранее Вы упоминали о ", Person, Answer), 
               write(Answer), writeln("."), 
               ask("Не могли бы Вы подробнее рассказать об этом человеке", Response), 
               (short_response(Response) *-> answer([6]), asserta(person(Person)), discuss([]);
                    find_patterns(user, Response, Patterns), discuss(Patterns)).
discuss([]) :- ask("Не хотели бы еще о чем-нибудь поговорить", Response),
               (short_response(Response) *-> answer([6]), discuss([]);
                    find_patterns(user, Response, Patterns), discuss(Patterns)). 
discuss([1 | _]) :- answer([1]), !.
discuss(Patterns) :- member(4, Patterns), answer([4]), discuss([]), !.                    
discuss([2 | Other]) :- ask("Скажите, как давно Вы испытываете это чувство", Response), 
                        (end_discussion(Response) *-> answer([1]); 
                            (uncertain_response(Response) *-> answer([13, 14]), discuss(Other);
                                find_patterns(period, Response, Patterns), answer(Patterns), discuss(Other))).
discuss([3 | Other]) :- ask("Пугает ли Вас это чувство любви", Response),
                        (end_discussion(Response) *-> answer([1]); 
                            (uncertain_response(Response) *-> answer([13, 14]), discuss(Other);
                                (short_response(Response) *-> answer([6]), discuss([3 | Other]);
                                    find_patterns(love, Response, Patterns), answer(Patterns), discuss(Other)))).

discuss([5 | Other]) :- get_feelling(Feelling), concat("Почему Вы испытываете ", Feelling, Questinon),
                        ask(Questinon, Response),
                        (end_discussion(Response) *-> answer([1]); 
                            (uncertain_response(Response) *-> answer([13, 14]), discuss(Other);
                                answer([5]), discuss(Other))).

discuss([7 | Other]) :- answer([7]), discuss(Other).
discuss([8 | Other]) :- writeln("Ранее вы сказали, что некоторая ситуация происходит всегда."),
                        ask("Не могли бы Вы привести пример", Response),
                        (end_discussion(Response) *-> answer([1]); 
                            (uncertain_response(Response) *-> answer([13, 14]), discuss(Other);
                                (short_response(Response) *-> answer([6]), discuss([8 | Other]);
                                    answer([8]), discuss(Other)))).

discuss([9 | Other]) :- ask("Если Вас не затруднит, не могли бы рассказать подробнее о своей семье", Response),
                        (end_discussion(Response) *-> answer([1]); 
                            (uncertain_response(Response) *-> answer([13, 14]), discuss(Other);
                                (short_response(Response) *-> answer([6]), discuss([9 | Other]);
                                    answer([9]), discuss(Other)))).                                   
