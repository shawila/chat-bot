Fabricator(:raid) do
  guild
  name { Faker::Name.name }
  raid_type { Faker::Number.between(0, 1) }

  transient :start, :phase_count
  phases do |attr|
    time = (attr[:start] || Time.zone.now) + 1.hour
    (0..(attr[:phase_count] || 2)).map { |i| Fabricate(:phase, start: (time + i.hours)) }
  end
end
