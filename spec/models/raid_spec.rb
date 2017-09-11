require 'rails_helper'

RSpec.describe Raid, type: :model do
  describe '#event_type' do
    it 'returns raid if passed type is pit' do
      expect(Raid.event_type(:pit)).to eq :raid
      expect(Raid.event_type('pit')).to eq :raid
    end

    it 'returns raid if passed type is tank' do
      expect(Raid.event_type(:tank)).to eq :raid
      expect(Raid.event_type('tank')).to eq :raid
    end

    it 'returns battle if passed type is hoth' do
      expect(Raid.event_type(:hoth)).to eq :battle
      expect(Raid.event_type('hoth')).to eq :battle
    end
  end

  describe '#display' do
    it 'returns the full display name: The Pit (NAME)' do
      raid = Fabricate(:raid, raid_type: 0)
      expect(raid.display).to eq "The Pit (#{raid.name})"
    end

    it 'returns just the raid type if name is empty' do
      raid = Fabricate(:raid, raid_type: 0, name: '')
      expect(raid.display).to eq 'The Pit'
    end

    context 'Tank raid' do
      it 'returns the full display name: Tank Takedown (NAME)' do
        raid = Fabricate(:raid, raid_type: 1)
        expect(raid.display).to eq "Tank Takedown (#{raid.name})"
      end
    end
  end

  describe '#passed?' do
    let(:start) { Time.zone.now + 4.hours }
    let(:raid) { Fabricate(:raid, start: start, phase_count: 4) } # 4 phases in the future

    it 'returns nil when some phases have not passed yet' do
      expect(raid.passed?).to be_nil
    end

    context 'some phases have not passed yet' do
      let(:start) { Time.zone.now - 2.hours } # 2 phases in the past

      it 'returns bil' do
        expect(raid.passed?).to be_nil
      end
    end

    context 'phases are all in the past' do
      let(:start) { Time.zone.now - 40.hours } # 4 phases in the past

      it 'returns the last phase' do
        expect(raid.passed?).to eq raid.phases.last
      end
    end
  end

  describe '#last_raid' do
    let!(:pit_raids) { Fabricate.times(3, :raid, raid_type: 0) }
    let!(:tank_raids) { Fabricate.times(3, :raid, raid_type: 1) }

    it 'returns the last raid of the passed type' do
      expect(Raid.last_raid(0)).to eq pit_raids.last
      expect(Raid.last_raid(1)).to eq tank_raids.last
    end
  end

  describe 'raid_info' do
    let(:guild) { Fabricate(:guild) }
    let(:start) { Time.zone.now + 9.hours }

    let!(:pit_raids) do
      [start, start + 9.hours].map { |time| Fabricate(:raid, guild: guild, start: time, raid_type: 0) }
    end
    let!(:tank_raids) do
      [start, start + 9.hours].map { |time| Fabricate(:raid, guild: guild, start: time, raid_type: 1) }
    end

    it 'returns first raid of the passed type' do
      expect(Raid.raid_info(guild.uid, types = [0])).to eq [pit_raids.first]
      expect(Raid.raid_info(guild.uid, types = [1])).to eq [tank_raids.first]
    end

    it 'returns all raids of the passed type if return_all is true' do
      expect(Raid.raid_info(guild.uid, types = [0], return_all = true)).to eq pit_raids
      expect(Raid.raid_info(guild.uid, types = [1], return_all = true)).to eq tank_raids
    end

    context 'one of the raids was in the near past (less than 9 hours ago)' do
      let(:start) { Time.zone.now - 9.hours } # raid will have one phase 9 hours ago and another 8 hours ago

      it 'returns two raids of the passed type' do
        raids = Raid.raid_info(guild.uid, [0])
        expect(pit_raids.first.phases.last.start).to be > Time.zone.now - 9.hours
        expect(pit_raids.last.phases.first.start).to be > Time.zone.now
        expect(raids).to eq pit_raids
      end
    end
  end
end
