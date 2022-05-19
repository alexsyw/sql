CREATE TABLE competition (
  competition_id serial NOT NULL, /* ID соревнования*/
  competition_name varchar(255) NOT NULL, /*наименование соревнования */
  world_record int NOT NULL, /* мировой рекорд*/
  set_date  date NOT NULL, /* дата установки мирового рекорда*/
  PRIMARY KEY (competition_id)
);

CREATE TABLE result (
  result_id serial NOT NULL, /* ID результата */
  competition_id int NOT NULL, /* ID соревнования */
  sportsman_id int NOT NULL, /* ID спортсмена */
  result int NOT NULL, /* результат спортсмена */
  city varchar(255) NOT NULL, /*  место проведения*/
  hold_date date NOT NULL, /* дата проведения */ 
  PRIMARY KEY (result_id) 
);

CREATE TABLE sportsman (
  sportsman_id serial NOT NULL, /* ID спортсмена */
  sportsman_name varchar(255) NOT NULL, /*имя спортсмена */
  rank  int NOT NULL, /*разряд спортсмена */
  year_of_birth  int NOT NULL, /*год рождения */
  personal_record  int NOT NULL, /* персональный рекорд*/
  country  varchar(255) NOT NULL, /*страна спортсмена */
  PRIMARY KEY (sportsman_id)
);


/* ПЗ 01 */

/* 4. Выдайте всю информацию о спортсменах из таблицы sportsman. */
select * from sportsman
/* 5. Выдайте наименование и мировые результаты по всем соревнованиям. */
select competition_name, world_record from competition
/* 6. Выберите имена всех спортсменов, которые родились в 1990 году.  */
select sportsman_name from sportsman where year_of_birth = 1990
/* 7. Выберите наименование и мировые результаты по всем соревнованиям, установленные 12-05-2010 или 15-05-2010. */
select competition_name, world_record from competition where set_date = '2010-05-12' or set_date = '2010-05-15'
/* 8. Выберите дату проведения всех соревнований, проводившихся в Москве и полученные на них результаты равны 10 секунд. */
select hold_date from result where city = 'Москва' and result = 10
/*9. Выберите имена всех спортсменов, у которых персональный рекорд не равен 25 с. */
select sportsman_name from sportsman where personal_record = 25
/* 10. Выберите названия всех соревнований, у которых мировой рекорд равен 15 с и дата установки рекорда не равна 12-02-2015.*/
select competition_name from competition where world_record = 15 and set_date = '2015-02-12'

/* ПЗ 02 */

/* 11. Выберите города проведения соревнований, где результаты принадлежат множеству {13, 25, 17, 9}. */
select city from result where result in (13, 25, 17, 9)
/* 12.Выберите имена всех спортсменов, у которых год рождения 2000 и разряд не принадлежит множеству {3, 7, 9}. */
select sportsman_name from sportsman where year_of_birth = 2000 and rank in (3,7,9)
/* 13.	Выберите дату проведения всех соревнований, у которых город проведения начинается с буквы "М".*/
select hold_date from result where city like 'М%'
/* 14. Выберите имена всех спортсменов, у которых имена начинаются с буквы "М" и год рождения не заканчивается на "6". */
select sportsman_name from sportsman where sportsman_name like 'М%' and year_of_birth not like '%6' /* вроде, единственное то что я не понял */
/* 15. Выберите наименования всех соревнований, у которых в названии есть слово "международные". */
select competition_name from competition where competition_name like 'Международные'
/* 16.	Выберите годы рождения всех спортсменов без повторений. */
select distinct year_of_birth from sportsman
/* 17. Найдите количество результатов, полученных 12-05-2014. */
select count(result_id) from result where hold_date = '2014-05-12'
/* 18.	Вычислите максимальный результат, полученный в Москве. */
select max(result) from result where city = 'Москва'
/*19. Вычислите минимальный год рождения спортсменов, которые имеют 1 разряд. */
select min(year_of_birth) from sportsman where rank = 1
/* 20. Определите имена спортсменов, у которых личные рекорды совпадают с результатами, установленными 12-04-2014. */
select sportsman_name from sportsman where personal_record = (select result from result where hold_date = '2014-04-12')

/* ПЗ 03 */

/*21.Выведите наименования соревнований, у которых дата установления мирового рекорда совпадает с датой проведения соревнований в Москве 20-04-2015. */ 
select competition_name from competition where set_date = (select hold_date from result where city = 'Москва' and hold_date = '2015-04-20')
/* 22.Вычислите средний результат каждого из спортсменов. */
select personal_record from sportsman group by sportsman_id
/* 23.	Выведите годы рождения спортсменов, у которых результат, показанный в Москве выше среднего по всем спортсменам. */
select year_of_birth from sportsman where personal_record = (select avg(result) from result where city = 'Москва')
/* 25.Выведите имена всех спортсменов, у которых разряд ниже среднего разряда всех спортсменов, родившихся в 2000 году.*/
select sportsman_name from sportsman where rank = (select avg(rank) from sportsman where year_of_birth = 2000)
/* 26. Выведите данные о спортсменах, у которых персональный рекорд совпадает с мировым. */
select * from sportsman where personal_record in (select world_record from competition)
/* 27.	Определите количество участников с фамилией Иванов, которые участвовали в соревнованиях с названием, содержащим слово 'Региональные' */
select count(result.sportsman_id) from result, sportsman, competition where sportsman.sportsman_name like 'Иванов' and competition.competition_name like 'Региональные'
/* 28. Выведите города, в которых были установлены мировые рекорды. */
select city from result where result = (select world_record from competition)
/* 29.	Найдите минимальный разряд спортсменов, которые установили мировой рекорд*/
select min(rank) from sportsman where personal_record = (select world_record from competition)
/* 30.	Выведите названия соревнований, на которых было установлено максимальное количество мировых рекордов. */
select competition_name, max(world_record) from competition group by competition_name

/* ПЗ 04 */

/* 31.	Определите, спортсмены какой страны участвовали в соревнованиях больше всего. */
select country, count(*) as x from sportsman 
left join result ON result.sportsman_id = sportsman.sportsman_id
left join competition ON competition.competition_id = result.competition_id
group by sportsman.country order by x desc 
/* 32.	Измените разряд на 1 тех спортсменов, у которых личный рекорд совпадает с мировым. */
update sportsman set rank = sportsman.rank+1 from competition as x where sportsman.personal_record=x.world_record
/* 33.	Вычислите возраст спортсменов, которые участвовали в соревнованиях в Москве.  */
select 2022 - year_of_birth from sportsman, result where result.city = 'Москва'
/* 34.	Измените дату проведения всех соревнований, проходящих в Москве на 4 дня вперед. */
update competition set set_date = competition.set_date+4 from result as x where x.city = 'Москва'
/* 35.	Измените страну у спортсменов, у которых разряд равен 1 или 2, с Италии на Россию. */
update sportsman set country = 'Россия' where rank = 1 or rank = 2 and country = 'Италия'
/* 36.	Измените название соревнований с 'Бег' на 'Бег с препятствиями' */
update competition set competition_name = 'Бег с препятствиями' where competition_name = 'Бег'
/* 37.	Увеличьте мировой результат на 2 с для соревнований ранее 20-03-2005. */
update competition set world_record = competition.world_record+2 where set_date < 2005-03-20
/* 38.	Уменьшите результаты на 2 с соревнований, которые проводились 20-05-2012 и показанный результат не менее 45 с. */
update result set result.result-2 where hold_date = 2012-05-20 and result = 45
/* 39.	Удалите все результаты соревнований в Москве, участники которых родились не позже 1980 г. */
delete from result where city = 'Москва' and sportsman_id = (select sportsman_id from sportsman where year_of_birth < 1980)
/* 40.	Удалите все соревнования, у которых результат равен 20 с. */
delete from result where result = 20
/* 41.	Удалите все результаты спортсменов, которые родились в 2001 году. */
delete from sportsman where year_of_birth = 2001