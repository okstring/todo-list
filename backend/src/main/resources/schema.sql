DROP TABLE IF EXISTS card;

CREATE TABLE card
(
    id                int AUTO_INCREMENT,
    title             varchar(50),
    contents          varchar(500),
    column_type       int,
    created_date_time datetime,
    primary key (id)
);

DROP TABLE IF EXISTS action;

CREATE TABLE action
(
    id                int AUTO_INCREMENT,
    action_type       varchar(50),
    card_title        varchar(50),
    created_date_time datetime,
    column_from       int,
    column_to         int,
    primary key (id)
);
