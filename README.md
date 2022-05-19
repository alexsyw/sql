# alexsyw/sql
## Самостоятельные запросы SQL (которые 30 штук) 
Запросы делались в СУБД PostgreSQL 13. Собственно я решил оформить их решение (советую не списывать, а учиться на чужих ошибках). ***Местами возможно смещение синтаксиса.***
~~да простит меня Дмитрий Юрьевич~~. Если появились вопросы по запросам обращайтесь с Pull Requests ;)

[Задонатить бедному студенту](https://alexsyw.me/tinkoff/donate)
1. Получить всю информацию о поставщиках
```mysql
select * from s;
```
2. Получить всю информацию о деталях.
```mysql
select * from p;
```

3. Получить список поставщиков, поставляющих деталь p1
```mysql
select distinct n_post from spj1 where n_det = 'P1'
```

4. Получить список деталей, поставляемых для изделия j5
```mysql
select distinct n_det from spj1 where n_izd = 'J5';
```

5.    Получить информацию о деталях, отсортировать результаты по цвету
```mysql
select * from p order by cvet;
```

6. Получить информацию о поставщике с наивысшим рейтингом
```mysql
select * from s order by reiting desc limit 1
```

7. Вывести средний рейтинг поставщиков.
```mysql
select avg(reiting) from s
```

8. Получить суммарное количество поставок для каждой детали.
```mysql
select n_det, sum(kol) from spj1 group by n_det;
```

9. Получить список изделий, для которых не выполнял поставки S1, а суммарное количество поставок больше 2000
```mysql
select n_izd from spj1 where n_spj not like 's1' group by n_izd having sum(kol)>2000
```

10.  Получить информацию о поставках, количество деталей в которых было больше всех поставок поставщика S2
```mysql
select n_post from spj1 where kol > all (select sum(kol) from spj1 where n_post = 'S2')
```

11. Получить список изделий детали для которых поставляются хотя бы одним поставщиком из Лондона.
```mysql
select * from j where town in (
select town from s where town = 'Лондон'
)
```

12. Получить номера изделий, для которых поставляется деталь P1
```mysql
select n_izd from j where n_izd in (
select n_izd from spj1 where n_det = 'P1'
)
```

13. Выдать фамилии поставщиков, поставляющих по крайней мере одну красную деталь.
```mysql
select name from s where n_post in (
select n_post from spj1 where n_det in (
select n_det from p where cvet = 'Красный'
))
```

14. Выдать номера поставщиков, поставляющих, по крайней мере, одну деталь, поставляемую поставщиком S2. (можно использовать одну и ту же таблицу и в самом запросе и подзапросе)
```mysql
select distinct n_post from spj1 where n_det in (
select n_det from spj1 where n_post = 'S2')
```

15. Выдать номера поставщиков, находящихся в том же городе, что и поставщик S1 (сделать подзапрос, для получения города и потом связать через where = (подзапрос))
```mysql
select distinct n_izd from spj1 as x where not exists ((select n_det from spj1 where n_izd = 'J3') except (select n_det from spj1 as y where x.n_izd=y.n_izd))
```

16. Получить номера и наименования изделий, для которых поставлялась каждая деталь, поставленная для изделия J3.
```mysql
select n_det, name from p where n_det in (select n_det from spj1 where n_izd = 'J3')
```

17. Выбрать поставщиков, не поставивших ни одной из деталей, имеющих наименьший вес
```mysql
select n_post from spj1 where not exists (select * from p)
UNION select n_post from spj1 where not exists (select min(ves) from p);
```

18. Выдать полную информацию о поставщиках, поставляющих только красные детали.
```mysql
select * from s where n_post in (
select n_post from spj1 where n_det in (select n_det from p where cvet = 'Красный'))
```

19. Выбрать поставщиков, поставляющих детали, поставляемые поставщиками, проживающими в Лондоне
```mysql
select distinct n_post from s where n_post in (
    select n_post from spj1 where n_det in (
        select n_det from p where town = 'Лондон'))
```

20. Получить список городов, в которые выполнили поставки только поставщики, поставляющие голубые детали.
```mysql
select town from j as x where not exists 
(
 select n_post from spj1 where spj1.n_izd = x.n_izd and n_det not in
 (
  select n_det from p where cvet = 'Голубой'
 )
)
```

21. Выбрать изделия, для которых поставщик с рейтингом 20 поставлял детали, поставляющиеся для изделия j2
```mysql
select * from j where n_izd in (
    select n_izd from spj1 whern_post in ( select n_post from s where reiting = 20) and n_det in (select n_det from spj1 where n_izd = 'J2')
```

22. Получить список поставщиков, выполнивших поставки только для изделий с красными деталями.
```mysql
select distinct n_post from s where n_post in (
    select n_post from spj1 where n_det in (
        select n_det from p where cvet = 'Красный'))
```

23. Выбрать поставщиков, поставляющих голубые детали, поставляемые для изделий с деталью P6.
```mysql
select n_post from spj1 where n_det in (select n_det from p where cvet = '' and n_det in (select n_det from spj1 where n_izd in  (select n_izd from spj1 where n_det = 'P6')))
 ```
 
24. Выбрать номера деталей, поставляемых более чем одним поставщиком (через x и y)
```mysql
select distinct y.n_det from spj1 as x
left join ( select n_det, n_post from spj1) as y on x.n_post = y.n_post where x.n_post = y.n_post group by y.n_det having count(distinct y.n_post) > 1
```
24.1. Аналогичный запрос (более оптимизированный):
```mysql
select n_det from spj1 group by n_det having count(distinct n_post) > 1
```

25. Выбрать номера деталей, поставляемых поставщиком S2
```mysql
select distinct n_det from spj1 where n_post = 'S2'
```

26. Выбрать фамилии поставщиков, которые поставляют все детали.
```mysql
select name from s where (select count(distinct n_det) from spj1 where spj1.n_post=s.n_post) = (select count(n_det) from p)
```

27. Вывести без повторений пары городов таких, что была поставка детали из первого города для изделия во втором городе. Упорядочить список по алфавиту
```mysql
select distinct y.town, n.town from spj1 as x 
left join ( select * from p ) as y on x.n_det=y.n_det
left join ( select * from s ) as n on x.n_post=n.n_post order by y.town, n.town
```

28.   Вывести полный список городов и для каждого города найти суммарное количество деталей красного цвета, которые были в него поставлены. Города в списке должны быть все.
```mysql
select distinct town, count(x.n_det) from p
natural join (
select spj1.n_det from spj1, p where p.cvet = 'Красный') as x group by p.town
```

29. Найти поставки такие, что поставщик, изделия и деталь размещены в одном и том же городе. Вывести номер поставщика, номер изделия, номер детали и город где размещены изделие, поставщик и деталь
```mysql
select distinct spj1.n_post, spj1.n_det, spj1.n_izd from spj1
left join s on s.n_post = spj1.n_post
left join p on p.n_det = spj1.n_det and s.town = p.town
left join j on j.n_izd=spj1.n_izd and p.town = j.town
```

30. Вывести полный список деталей и для каждой детали определить, сколько поставщиков с рейтингом меньше 30 поставляли эту деталь. Детали в списке должны быть все.
```mysql
select p.n_det, p.name, p.ves, count(x.n_post) from p 
left join (
    select * from spj1 where n_post in (select n_post from s where reiting<30)
) as x on p.n_det=x.n_det group by p.n_det, p.name, p.ves
```
