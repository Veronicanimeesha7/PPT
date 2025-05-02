Create database TicketBookingSystem;
use TicketBookingSystem; 

Create table Venue (
    venue_id int primary key auto_increment,
    venue_name varchar(100) not null,
    address varchar(255)
);
drop table Event
Create table Event (
    event_id int primary key auto_increment,
    event_name varchar(100) not null,
    event_date date not null,
    event_time time not null,
    venue_id int,
    total_seats int not null,
    available_seats int not null,
    ticket_price decimal(10, 2) not null,
    event_type enum('Movie', 'Sports', 'Concert') not null,
    foreign key (venue_id) references Venue(venue_id)
);

Create table Customer (
    customer_id int primary key auto_increment,
    customer_name varchar(100) not null,
    email varchar(100),
    phone_number varchar(20)
);

Create table Booking (
    booking_id int primary key auto_increment,
    customer_id int,
    event_id int,
    num_tickets int not null,
    total_cost decimal(10, 2),
    booking_date timestamp default current_timestamp,
    foreign key (customer_id) references Customer(customer_id),
    foreign key (event_id) references Event(event_id)
);

use  TicketBookingSystem; 
insert into Venue (venue_id, venue_name, address) values
(1, 'Grand Arena', '123 Main St'),
(2, 'City Auditorium', '456 Elm St'),
(3, 'Open Grounds', '789 Oak St'),
(4, 'The Royal Theatre', '321 Maple St'),
(5, 'Rock Dome', '654 Pine St');



insert into Event (event_id, event_name, event_date, event_time, venue_id, total_seats, available_seats, ticket_price, event_type) values
(1, 'Rock Concert', '2025-06-01', '19:00:00', 1, 5000, 1000, 1500, 'Concert'),
(2, 'Comedy Cup', '2025-07-10', '18:00:00', 2, 3000, 0, 1000, 'Movie'),
(3, 'Music Fiesta', '2025-05-20', '20:00:00', 3, 8000, 2000, 2000, 'Concert'),
(4, 'Drama Night', '2025-05-25', '18:30:00', 4, 1500, 300, 750, 'Movie'),
(5, 'Football Cup', '2025-06-15', '17:00:00', 5, 20000, 15000, 2500, 'Sports');

insert into Customer (customer_id, customer_name, email, phone_number) values
(1, 'Alice Johnson', 'alice@example.com', '9876543000'),
(2, 'Bob Smith', 'bob@example.com', '9876543100'),
(3, 'Charlie Brown', 'charlie@example.com', '9876543200'),
(4, 'Daisy Lee', 'daisy@example.com', '9876543300'),
(5, 'Ethan Hunt', 'ethan@example.com', '9876543400');

insert into  Booking (customer_id, event_id, num_tickets, total_cost, booking_date)
values
(1, 1, 2, 3000.00, '2025-04-10'),
(2, 1, 1, 1500.00, '2025-04-11'),
(3, 2, 4, 6000.00, '2025-04-12'),
(4, 3, 3, 4500.00, '2025-04-13'),
(5, 2, 2, 3000.00, '2025-04-14');

select * from Event;

select * from Event where available_seats > 0;

select * from Event where event_name like '%cup%';

select * from Event where ticket_price between 1000 and 2500;

select * from Event where event_date between '2025-06-01' and '2025-07-01';

select * from Event where available_seats > 0 and event_type = 'Concert' and event_name like '%Concert%';

select * from Customer limit 5 offset 5;

select * from Booking where num_tickets > 4;

select * from Customer where phone_number like '%000';

select * from Event where total_seats > 15000 order by total_seats desc;

select * from Event where event_name not like 'x%' and event_name not like 'y%' and event_name not like 'z%';

select event_name, avg(ticket_price) as avg_price
from Event
group by event_name;


select event_id, sum(total_cost) as total_revenue
from Booking
group by event_id;


select event_id, sum(num_tickets) as total_tickets
from Booking
group by event_id
order by total_tickets DESC
limit 1;


select E.event_name, sum(B.num_tickets) as tickets_sold
from Booking B
join Event E on B.event_id = E.event_id
group by E.event_id;


select event_name
from Event
where event_id not in (select distinct event_id from Booking);


select C.customer_name, sum(B.num_tickets) as total_tickets
from Booking B
join Customer C on B.customer_id = C.customer_id
group by B.customer_id
order by total_tickets desc
limit 1;


select month(booking_date) as booking_month, sum(num_tickets) as total_tickets
from Booking
group by month(booking_date);


select V.venue_name, avg(E.ticket_price) as avg_price
from Event E
join Venue V on E.venue_id = V.venue_id
group by V.venue_id;


select event_type, sum(B.num_tickets) as total_tickets
from Booking B
join Event E on B.event_id = E.event_id
group by event_type;


select year(booking_date) as year, sum(total_cost) as revenue
from Booking
group by year(booking_date);


select customer_id
from Booking
group by customer_id
having COUNT(distinct event_id) > 1;


select C.customer_name, sum(B.total_cost) as user_revenue
from Booking B
join Customer C on B.customer_id = C.customer_id
group by C.customer_id;


select event_type, venue_id, avg(ticket_price) as avg_price
from Event
group by event_type, venue_id;


select C.customer_name, sum(B.num_tickets) as total_tickets
from Booking B
join Customer C on B.customer_id = C.customer_id
where booking_date >= curdate() - interval 30 day
group by C.customer_id;

select venue_id,
       (select avg(ticket_price) from Event E2 where E2.venue_id = E1.venue_id) as avg_price
from Event E1
group by venue_id;

select event_name
from Event
where event_id in (
  select event_id
  from Booking
  group by event_id
  having sum(num_tickets) > (
    select total_seats / 2 from Event E where E.event_id = Booking.event_id
  )
);

select event_id,
       (select sum(num_tickets) from Booking B where B.event_id = E.event_id) as tickets_sold
from Event E;

select customer_name
from Customer C
where not exists (
  select 1 from Booking B where B.customer_id = C.customer_id
);

select event_name
from Event
where event_id not in (
  select distinct event_id from Booking
);

select event_type, sum(tickets_sold) as total_tickets
from (
  select E.event_type, B.num_tickets as tickets_sold
  from Booking B
  join Event E on B.event_id = E.event_id
) as sub
group by event_type;

select *
from Event
where ticket_price > (
  select avg(ticket_price) from Event
);

select customer_id,
       (select sum(total_cost)
        from Booking B2
        where B2.customer_id = B1.customer_id) as total_revenue
from Booking B1
group by customer_id;

select distinct C.customer_name
from Customer C
where C.customer_id in (
    select B.customer_id
    from Booking B
    join Event E on B.event_id = E.event_id
    where E.venue_id = 1
);

select event_type, sum(tickets_sold) as total_tickets
from (
    select E.event_type, B.num_tickets as tickets_sold
    from Booking B
	join Event E on B.event_id = E.event_id
)  as sub
group by event_type;

select distinct C.customer_name, DATE_FORMAT(B.booking_date, '%Y-%m') as booking_month
from Booking B
join Customer C on B.customer_id = C.customer_id
order by booking_month, customer_name;

select V.venue_name,
       (select avg(E2.ticket_price)
        from Event E2
        where E2.venue_id = V.venue_id) as avg_ticket_price
from Venue V;
