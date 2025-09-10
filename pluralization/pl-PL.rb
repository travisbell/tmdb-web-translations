require 'rails_i18n/pluralization'

{ :'pl-PL' => {
    :'i18n' => {
      :plural => {
        :keys => [:one, :few, :many, :other],
        :rule => ::RailsI18n::Pluralization::Polish.rule }}}}
