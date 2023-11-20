CREATE SCHEMA IF NOT EXISTS `krampoline` DEFAULT CHARACTER SET utf8mb4;

GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY 'root' WITH GRANT OPTION;
GRANT ALL ON krampoline.* TO 'root'@'localhost';
FLUSH PRIVILEGES;

USE `krampoline`;

# DROP TABLE IF EXISTS `sample_data`;
# CREATE TABLE `sample_data` (
#     `id` int(11) NOT NULL AUTO_INCREMENT,
#     `detail` varchar(100) NOT NULL,
#     PRIMARY KEY (`id`)
# ) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

# INSERT INTO sample_data (`id`,`detail`) VALUES ('1', 'Hello DKOS!');

DROP TABLE IF EXISTS `apply`;
create table `apply` (
    id bigint auto_increment primary key,
    created_at timestamp,
    created_by bigint,
    deleted_at timestamp,
    last_updated_by bigint,
    updated_at timestamp,
    status varchar(255) not null,
    detail_worktime_id bigint,
    user_id bigint,
    foreign key (detail_worktime_id) references detail_worktime(id),
    foreign key (user_id) references users(id)
);

DROP TABLE IF EXISTS `detail_worktime`;
create table `detail_worktime` (
    id bigint auto_increment primary key,
    created_at timestamp,
    created_by bigint,
    deleted_at timestamp,
    last_updated_by bigint,
    updated_at timestamp,
    amount bigint not null,
    date date not null,
    day_of_week integer not null,
    worktime_id bigint,
    foreign key (worktime_id) references worktime(id)
);

DROP TABLE IF EXISTS `groups`;
create table `groups` (
    id bigint auto_increment primary key,
    created_at timestamp,
    created_by bigint,
    deleted_at timestamp,
    last_updated_by bigint,
    updated_at timestamp,
    address varchar(100) not null,
    business_number varchar(255),
    name varchar(50) not null,
    phone_number varchar(13)
);

DROP TABLE IF EXISTS `invite`;
create table `invite` (
    id bigint auto_increment primary key,
    created_at timestamp,
    created_by bigint,
    deleted_at timestamp,
    last_updated_by bigint,
    updated_at timestamp,
    code varchar(255) not null,
    renewed_at timestamp,
    group_id bigint not null,
    foreign key (group_id) references groups(id)
);

DROP TABLE IF EXISTS `notification`;
create table `notification` (
    id bigint auto_increment primary key,
    created_at timestamp,
    created_by bigint,
    deleted_at timestamp,
    last_updated_by bigint,
    updated_at timestamp,
    content varchar(200) not null,
    is_read boolean not null,
    type varchar(255) not null,
    user_id bigint not null,
    foreign key (user_id) references users(id)
);

DROP TABLE IF EXISTS `recommended_weekly_schedule`;
create table `recommended_weekly_schedule` (
    id bigint auto_increment primary key,
    created_at timestamp,
    created_by bigint,
    deleted_at timestamp,
    last_updated_by bigint,
    updated_at timestamp,
    week_id bigint,
    foreign key (week_id) references week(id)
);

DROP TABLE IF EXISTS `recommended_worktime_apply`;
create table `recommended_worktime_apply` (
    id bigint auto_increment primary key,
    created_at timestamp,
    created_by bigint,
    deleted_at timestamp,
    last_updated_by bigint,
    updated_at timestamp,
    apply_id bigint,
    recommended_weekly_schedule_id bigint,
    foreign key (apply_id) references apply(id),
    foreign key (recommended_weekly_schedule_id) references recommended_weekly_schedule(id)
);

DROP TABLE IF EXISTS `roles`;
create table `roles` (
    id bigint auto_increment primary key,
    created_at timestamp,
    created_by bigint,
    deleted_at timestamp,
    last_updated_by bigint,
    updated_at timestamp,
    role varchar(255),
    user_id bigint,
    foreign key (user_id) references users(id)
);

DROP TABLE IF EXISTS `substitute`;
create table `substitute` (
    id bigint auto_increment primary key,
    created_at timestamp,
    created_by bigint,
    deleted_at timestamp,
    last_updated_by bigint,
    updated_at timestamp,
    admin_approve boolean not null,
    content varchar(255) not null,
    applicant_id bigint not null,
    receptionist_id bigint,
    foreign key (applicant_id) references apply(id),
    foreign key (receptionist_id) references apply(id)
);

DROP TABLE IF EXISTS `unfinished_user`;
create table `unfinished_user` (
    id bigint auto_increment primary key,
    code varchar(255) not null,
    kakao_id bigint not null
);

DROP TABLE IF EXISTS `users`;
create table `users` (
    id bigint auto_increment primary key,
    created_at timestamp,
    created_by bigint,
    deleted_at timestamp,
    last_updated_by bigint,
    updated_at timestamp,
    is_admin boolean not null,
    kakao_id bigint not null,
    name varchar(10) not null,
    phone_number varchar(13),
    group_id bigint,
    foreign key (group_id) references groups(id)
);

DROP TABLE IF EXISTS `week`;
create table `week` (
    id bigint auto_increment primary key,
    created_at timestamp,
    created_by bigint,
    deleted_at timestamp,
    last_updated_by bigint,
    updated_at timestamp,
    start_date date not null,
    status varchar(255) not null,
    group_id bigint not null,
    foreign key (group_id) references groups(id)
);

DROP TABLE IF EXISTS `worktime`;
create table `worktime` (
    id bigint auto_increment primary key,
    created_at timestamp,
    created_by bigint,
    deleted_at timestamp,
    last_updated_by bigint,
    updated_at timestamp,
    end_time time not null,
    start_time time not null,
    title varchar(255) not null,
    week_id bigint,
    foreign key (week_id) references week(id)
);

alter table `groups` 
    drop index if exists UK_m4o7lnepjkys90x8uynphxn3h;

alter table `groups` 
    add constraint UK_m4o7lnepjkys90x8uynphxn3h unique (business_number);

alter table `invite` 
    drop index if exists groupInviteCode;

alter table `invite` 
    add constraint groupInviteCode unique (code);

alter table `apply` 
    add constraint FKat3fv0lk7onx0ce51lhn8cpog 
    foreign key (detail_worktime_id) 
    references detail_worktime(id);

alter table `apply` 
    add constraint FK8sbyo97sbtbkbrjpr3mcj431d 
    foreign key (user_id) 
    references users(id);

alter table `detail_worktime` 
    add constraint FKasiod7jkhb0dh2278kcdsdbts 
    foreign key (worktime_id) 
    references worktime(id);

alter table `invite` 
    add constraint FKk1p9cx2f2ky7yph1hxqxp9y4i 
    foreign key (group_id) 
    references groups(id);

alter table `notification` 
    add constraint FKnk4ftb5am9ubmkv1661h15ds9 
    foreign key (user_id) 
    references users(id);

alter table `recommended_weekly_schedule` 
    add constraint FKj0lrclog785kj6r3og7nw8rn3 
    foreign key (week_id) 
    references week(id);

alter table `recommended_worktime_apply` 
    add constraint FKgrpxyeda0mqiu5ofi4t2bq2if 
    foreign key (apply_id) 
    references apply(id);

alter table `recommended_worktime_apply` 
    add constraint FKoo91ld2r1hu3j1dlwyh3871 
    foreign key (recommended_weekly_schedule_id) 
    references recommended_weekly_schedule(id);

alter table `roles` 
    add constraint FK97mxvrajhkq19dmvboprimeg1 
    foreign key (user_id) 
    references users(id);

alter table `substitute` 
    add constraint FK319me5laup6jvj7apbeq9f2dw 
    foreign key (applicant_id) 
    references apply(id);

alter table `substitute` 
    add constraint FKndnlav6soqwod8h5v50jr4t01 
    foreign key (receptionist_id) 
    references apply(id);

alter table `users` 
    add constraint FKemfuglprp85bh5xwhfm898ysc 
    foreign key (group_id) 
    references groups(id);

alter table `week` 
    add constraint FKta7662paabhbrv3cfig3nrmye 
    foreign key (group_id) 
    references groups(id);

alter table `worktime` 
    add constraint FKenvqp8a4tbxv1l4ije9f31jp5 
    foreign key (week_id) 
    references week(id);

insert into `groups` (id, name, phone_number, business_number, address)
values ('1', '맘스터치', '011-0000-0001', '1', '부산광역시');

insert into `users` (id, kakao_id, name, phone_number, is_admin, group_id)
values ('1', '3040993001', '이재훈', '010-0000-0001', 'true', '1');

insert into `roles` (id, role_type, user_id)
values ('1', 'ROLE_ADMIN', '1');