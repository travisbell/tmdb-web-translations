require 'rails_i18n/pluralization'

{ :'ar-SA' => {
    :'i18n' => {
      :plural => {
        :keys => [:zero, :one, :two, :few, :many, :other],
        :rule => ::RailsI18n::Pluralization::Arabic.rule }}}}
