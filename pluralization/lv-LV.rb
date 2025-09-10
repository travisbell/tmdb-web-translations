require 'rails_i18n/pluralization'

{ :'lv-LV' => {
    :'i18n' => {
      :plural => {
        :keys => [:one, :other],
        :rule => ::RailsI18n::Pluralization::Latvian.rule }}}}
