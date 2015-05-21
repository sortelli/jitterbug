module.exports = (env) ->
  knex = require('knex')(
    client: 'sqlite3',
    connection:
      filename: __dirname + "/db/#{env}.db"
  )

  knex.schema.hasTable('jitterbugs').then (exists) ->
    if (!exists)
      knex.schema.createTable 'jitterbugs', (table) ->
        table.increments('id').primary()
        table.string('author_email', 200)
        table.text('code')

  return knex
