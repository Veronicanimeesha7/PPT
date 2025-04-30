Create database TicketBookingSystem;
use TicketBookingSystem; 

Create table Venue (
    venue_id int primary key auto_increment,
    venue_name varchar(100) not null,
    address varchar(255)
);

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