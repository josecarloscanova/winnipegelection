require 'spec_helper'

describe ElectoralRace do
  context 'when an electoral race has an associated region and election' do
    let(:electoral_race) do
      FactoryGirl.build(:electoral_race_with_region_and_election)
    end
    subject        { electoral_race }
    it             { is_expected.to be_valid }
    it 'has accessible associations of the correct type' do
      expect(electoral_race.region).to be_a(Region)
      expect(electoral_race.election).to be_a(Election)
    end
  end

  context 'when an electoral race has no associated region or election' do
    let(:electoral_race) { FactoryGirl.build(:electoral_race) }
    subject              { electoral_race }
    it                   { is_expected.to_not be_valid }
  end

  context 'when an electoral race has associated candidacies' do
    let(:electoral_race) do
      FactoryGirl.create(:electoral_race_with_candidacies,
                         candidacy_count: ASSOCIATION_COUNT)
    end
    subject { electoral_race }
    it      { is_expected.to have(ASSOCIATION_COUNT).candidacies }
    it      { is_expected.to have(ASSOCIATION_COUNT).people }
  end
end