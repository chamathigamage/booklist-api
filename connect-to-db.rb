require 'sequel'
Sequel.connect(
    {
        adapter: 'mysql2',
        host: 'localhost',
        user: 'root',
        password:'password',
        database: 'booklist',

    },
)