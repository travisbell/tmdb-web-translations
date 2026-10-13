# frozen_string_literal: true

RSpec.describe(Weblate::TypedNumberFormats) do
  example "coerces string booleans and precision" do
    input = {
      currency: { format: { precision: "2", significant: "False", strip_insignificant_zeros: "True", unit: "Ft" } },
      precision: { format: { delimiter: "" } }
    }

    expect(described_class.coerce(input)).to(eq(
      currency: { format: { precision: 2, significant: false, strip_insignificant_zeros: true, unit: "Ft" } },
      precision: { format: { delimiter: "" } }
    ))
  end

  example "drops values that are blank or not parseable" do
    input = { format: { precision: "৩", significant: "錯誤", strip_insignificant_zeros: "", separator: "," } }

    expect(described_class.coerce(input)).to(eq(format: { separator: "," }))
  end

  example "leaves typed values alone" do
    input = { format: { precision: 3, significant: true, strip_insignificant_zeros: false } }

    expect(described_class.coerce(input)).to(eq(input))
  end

  example "loaded locale number formats are typed" do
    I18n.available_locales.each do |locale|
      [:format, :"currency.format", :"human.format", :"percentage.format", :"precision.format"].each do |scope|
        format = I18n.t(:"number.#{scope}", locale: locale, default: {})
        next unless format.is_a?(Hash)

        expect(format[:precision]).to(be_nil.or(be_a(Integer)), "#{locale} number.#{scope}.precision")
        [:significant, :strip_insignificant_zeros].each do |key|
          expect([nil, true, false]).to(include(format[key]), "#{locale} number.#{scope}.#{key}")
        end
      end
    end
  end
end
