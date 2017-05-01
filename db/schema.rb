# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170501131115) do

  create_table "city_amounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name"
    t.string  "amount"
    t.decimal "long",     precision: 10
    t.decimal "lat",      precision: 10
    t.boolean "in_china"
  end

  create_table "obor_countries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string  "name"
    t.string  "code"
    t.decimal "total",          precision: 10
    t.decimal "percent_change", precision: 10
    t.string  "now"
    t.string  "history"
  end

  create_table "total_amounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal "total",    precision: 10
    t.decimal "export",   precision: 10
    t.string  "now"
    t.string  "forecast"
    t.string  "history"
  end

end
