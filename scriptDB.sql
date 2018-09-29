#Выведите все позиций списка товаров принадлежащие какой-либо категории с названиями товаров и названиями категорий. 
#Список должен быть отсортирован по названию товара, названию категории. Для соединения таблиц необходимо использовать оператор INNER JOIN.
#Ожидаемый формат результата:

+-------------+----------------+
| good_name   | category_name  |
+-------------+----------------+
| good 1      | category 1     |
| good 1      | category 2     |
| good 2      | category 3     |
| good 2      | category 4     |
| good 3      | category 7     |

use store;
desc category;
desc good;
select t3.name good_name, t1.name category_name
from category t1 
join category_has_good t2 on (t1.id = t2.category_id)
join good t3 on (t2.good_id = t3.id)
order by 1,2;

#Выведите список клиентов (имя, фамилия) и количество заказов данных клиентов, имеющих статус "new".
#Ожидаемый формат результата:

+------------+------------+----------------------+
| first_name | last_name  | new_sale_num         |
+------------+------------+----------------------+
| Ivan       | Ivanov     |                   10 |
| Petr       | Petrov     |                    7 |
| Semen      | Sidorov    |                    7 |
| Frank     | Sinatra    |                    2 |
| Ella       | Fitzgerald |                    1 |
;
desc client;
desc status;select * from status;
desc sale;
select t1.first_name, t1.last_name, count(t2.id) new_sale_num
from client t1 
join sale t2 on (t1.id = t2.client_id and t2.status_id=1)
group by t1.first_name, t1.last_name
order by 1,2;

#Выведите список товаров с названиями товаров и названиями категорий, в том числе товаров, не принадлежащих ни одной из категорий.
#Ожидаемый формат результата:

+-------------+----------------+
| good_name   | category_name  |
+-------------+----------------+
| good 1      | category 1     |
| good 1      | category 2     |
| good 2      | category 3     |
| good 2      | category 4     |
| good 3      | category 7     |
;
select t3.name good_name, t1.name category_name
from good t3
left join category_has_good t2 on (t2.good_id = t3.id)
left join category t1 on (t1.id = t2.category_id)
order by 1,2;

#Выведите список товаров с названиями категорий, в том числе товаров, не принадлежащих ни к одной из категорий, в том числе категорий не содержащих ни одного товара.
#Ожидаемый формат результата:

+-------------+----------------+
| good_name   | category_name  |
+-------------+----------------+
| good 1      | category 1     |
| good 1      | category 2     |
| good 2      | category 3     |
| good 2      | category 4     |
| good 3      | category 7     |
;

select t3.name good_name, t1.name category_name
from good t3
left join category_has_good t2 on (t2.good_id = t3.id)
left join category t1 on (t1.id = t2.category_id)
union
select t3.name good_name, t1.name category_name
from good t3
right join category_has_good t2 on (t2.good_id = t3.id)
right join category t1 on (t1.id = t2.category_id)
order by 1,2;

#Выведите список всех источников клиентов и суммарный объем заказов по каждому источнику. Результат должен включать также записи для источников, по которым не было заказов.
#Ожидаемый формат результата:

+-------------+----------------+
| source_name | sale_sum       |
+-------------+----------------+
| source 1    | 111.00         |
| source 2    | 222.00         |
| source 3    | 333.00         |
;

desc source;select * from source;
select t3.name source_name, sum(t2.sale_sum) sale_num
from client t1 
join sale t2 on (t1.id = t2.client_id)
right join source t3 on (t1.source_id = t3.id)
group by t3.name
order by 1;

#Выведите названия товаров, которые относятся к категории 'Cakes' или фигурируют в заказах текущий статус которых 'delivering'. 
#Результат не должен содержать одинаковых записей. В запросе необходимо использовать оператор UNION для объединения выборок по разным условиям.
#Ожидаемый формат результата:

+-------------+
| good_name   |
+-------------+
| good 1      |
| good 2      |
| good 3      |
;
desc category;select * from category;select * from status;
select t1.name
from good t1
join category_has_good t2 on (t1.id = t2.good_id)
join category t3 on (t2.category_id = t3.id and t3.name='Cakes')
union
select t1.name
from good t1
join sale_has_good t2 on (t1.id = t2.good_id)
join sale t3 on (t2.sale_id = t3.id and status_id = 5)
order by 1

#Выведите список всех категорий продуктов и количество продаж товаров, относящихся к данной категории. 
#Под количеством продаж товаров подразумевается суммарное количество единиц товара данной категории, фигурирующих в заказах с любым статусом.
#Ожидаемый формат результата:

+---------------------+----------+
| name                | sale_num |
+---------------------+----------+
| category 1          |       11 |
| category 2          |       25 |
| category 3        |       13 |
;
select * from sale;desc sale;select * from category;
select t1.name, count(t5.id) sale_sum
from category t1
left join category_has_good t2 on (t1.id = t2.category_id)
left join good t3 on (t2.good_id = t3.id)
left join sale_has_good t4 on (t3.id = t4.good_id)
left join sale t5 on (t4.sale_id = t5.id)
group by t1.name
order by t1.name;

#Выведите список источников, из которых не было клиентов, либо клиенты пришедшие из которых не совершали заказов или отказывались от заказов. 
#Под клиентами, которые отказывались от заказов, необходимо понимать клиентов, у которых есть заказы, которые на момент выполнения запроса находятся в состоянии 'rejected'. 
#В запросе необходимо использовать оператор UNION для объединения выборок по разным условиям.
#Ожидаемый формат результата:

+-------------+
| source_name |
+-------------+
| source 1    |
| source 2    |
| source 3    |
;select * from status
;
select t1.name
from source t1
left join client t2 on (t1.id = t2.source_id)
where t2.source_id is null
union
select t1.name
from source t1
join client t2 on (t1.id = t2.source_id)
left join sale t3 on (t3.client_id = t2.id)
where t3.client_id is null
union
select t1.name
from source t1
join client t2 on (t1.id = t2.source_id)
left join sale t3 on (t3.client_id = t2.id and t3.status_id=7)
;

SELECT t1.name
FROM source t1
WHERE NOT EXISTS (SELECT 1 FROM client t2 WHERE t1.id = t2.source_id)
union
select t1.name
from source t1
join client t2 on (t1.id = t2.source_id)
where not exists (select 1 from sale t3 where t3.client_id = t2.id)
union
select t1.name
from source t1
join client t2 on (t1.id = t2.source_id)
join sale t3 on (t3.client_id = t2.id and t3.status_id=7)
;
##########################
#В импортированной базе магазина посмотрите план следующего запроса:
explain
select 
  name, 
    ifnull((select category.name from category 
    join category_has_good on category.id=category_has_good.category_id
        where category_has_good.good_id=good.id
        order by category.name limit 1)
  , 0) as first_category 
from good where name like 'F%'
#from good where name='F%';
#Сколько кортежей будет обработано из таблицы good?
#322

#Создайте B-tree индекс на поле с названием товара в отношении good.
;
create index ind_good_name on good(name);
explain
select 
  name, 
    ifnull((select category.name from category 
    join category_has_good on category.id=category_has_good.category_id
        where category_has_good.good_id=good.id
        order by category.name limit 1)
  , 0) as first_category 
from good where name like 'F%'
#from good where name='F%';
#Сколько теперь кортежей будет обработано из таблицы good?

#Укажите, в каком порядке будут выполняться операции над отношениями в следующем запросе:
;
explain
select number, code from sale 
join client on sale.client_id=client.id
join status on status.id=status_id
where status.id in (6, 7);

#Добавить таблицу 'best_offer_sale' со следующими полями:
#    Название: `id`, тип данных: INT, возможность использования неопределенного значения: Нет, первичный ключ
#    Название: `name`, тип данных: VARCHAR(255), возможность использования неопределенного значения: Да
#    Название: `dt_start`, тип данных: DATETIME, возможность использования неопределенного значения: Нет
#    Название: `dt_finish`, тип данных: DATETIME, возможность использования неопределенного значения: Нет
#NB! При выполнении CREATE TABLE не следует указывать название схемы.

;
CREATE TABLE `best_offer_sale` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `dt_start` datetime NOT NULL,
  `dt_finish` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
create table best_offer_sale
(id INT NOT NULL,
name VARCHAR(255),
dt_start DATETIME NOT NULL,
dt_finish DATETIME NOT NULL,
primary key(id)
)
;
alter table sale_has_good
add column num INT NOT NULL,
add column price DECIMAL(18,2) NOT NULL
;
alter table client
add column source_id INT,
add constraint fk_source_id foreign key (source_id) references source(id)
;


#################################################################################################################
#EXAM
select * from billing where currency='USD'
;update billing set sum=1 where sum<200
;
#Выведите количество заказов в каждом статусе. Список должен быть отсортирован по количеству заказов в обратно порядке, по названию статуса в алфавитном. 
#Для соединения таблиц необходимо использовать оператор INNER JOIN.
#Ожидаемый формат результата:

+-------------+------------+
| status_name | sale_count |
+-------------+------------+
| status 1    | 10         |
| status 2    | 8          |
| status 3    | 8          |
| status 4    | 7          |
| status 5    | 5          |
;
select t1.name status_name, count(1) sale_count
from status t1
join sale t2 on (t1.id = t2.status_id)
group by t1.name
order by 2 desc, 1 asc;
#Выведите название категории, товары которой лучше всего продавались, и количество продаж товаров в данной категории. 
#"Лучше всего продавались" означает, что в данного товара было продано в штуках больше других. 
#Для соединения таблиц необходимо использовать оператор INNER JOIN.
#Ожидаемый формат результата:

+---------------+-------------+
| category_name | sale_count  |
+---------------+-------------+
| category 5    | 123         |
+---------------+-------------+
;
select t1.name category_name, count(t5.id) sale_count
from category t1
join category_has_good t2 on (t1.id = t2.category_id)
join good t3 on (t2.good_id = t3.id)
join sale_has_good t4 on (t3.id = t4.good_id)
join sale t5 on (t4.sale_id = t5.id)
group by t1.name
order by 2 desc limit 1