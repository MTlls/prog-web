# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_08_02_040135) do
  create_table "autors", force: :cascade do |t|
    t.string "nome", null: false
    t.string "nacionalidade", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "carteirinhas", force: :cascade do |t|
    t.boolean "podeEmprestar", null: false
    t.integer "pessoa_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pessoa_id"], name: "index_carteirinhas_on_pessoa_id"
  end

  create_table "carteirinhas_livros", force: :cascade do |t|
    t.integer "carteirinha_id", null: false
    t.integer "livro_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "data_emprestimo"
    t.datetime "data_devolucao"
    t.index ["carteirinha_id"], name: "index_carteirinhas_livros_on_carteirinha_id"
    t.index ["livro_id"], name: "index_carteirinhas_livros_on_livro_id"
  end

  create_table "livros", force: :cascade do |t|
    t.string "titulo", null: false
    t.string "ano", null: false
    t.string "genero", null: false
    t.integer "quantidade", null: false
    t.integer "autor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "emprestados"
    t.index ["autor_id"], name: "index_livros_on_autor_id"
  end

  create_table "pessoas", force: :cascade do |t|
    t.string "nome", null: false
    t.integer "cpf", null: false
    t.string "email", null: false
    t.string "telefone", null: false
    t.string "endereco", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "privilegio", default: 1, null: false
  end

  add_foreign_key "carteirinhas", "pessoas"
  add_foreign_key "carteirinhas_livros", "carteirinhas"
  add_foreign_key "carteirinhas_livros", "livros"
  add_foreign_key "livros", "autors"
end
