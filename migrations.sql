CREATE TABLE book (title TEXT, author TEXT, isbn INTEGER)
insert into book (title, author, isbn)
VALUES ('nothing', 'noone', 123);
insert into book (title, author, isbn)
VALUES ('Foundation', 'Isaac Asimov', 0553293354);
insert into book (title, author, isbn)
VALUES ('Dune', 'Frank Herbert', 0441172717);
insert into book (title, author, isbn)
VALUES (
        'Hyperion (Hyperion Cantos)',
        'Dan Simmons',
        0553283685
    );
CREATE INDEX book_id ON book(isbn);
ALTER TABLE book
ADD PRIMARY KEY (isbn);
ALTER TABLE book
MODIFY COLUMN isbn VARCHAR(13);
insert into book (title, author, isbn)
VALUES ('Hello', 'Chamathi Gamage', '245j56jgs248i');