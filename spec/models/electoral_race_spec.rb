require 'spec_helper'
require 'concerns/friendly_url_spec'

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
    it 'has a composite name via region and election' do
      electoral_race.election.election_date = Date.parse('2014-10-22')
      expect(electoral_race.name).to eq('Mayoral: Winnipeg - 2014')
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

    describe '#candidates_and_seats_message' do
      it 'returns a message describing the candidate and seat count' do
        electoral_race.seats_to_fill = 3
        expect(electoral_race.candidates_and_seats_message).to \
          eq('There are 2 candidates competing for 3 seats in this race.')
      end
      it 'return a shorter message when seat count is one' do
        electoral_race.seats_to_fill = 1
        expect(electoral_race.candidates_and_seats_message).to \
          eq('There are 2 candidates in this race.')
      end
    end

    describe '#updated_at_including_news_articles' do
      let(:electoral_race) { electoral_races(:city_of_winnipeg_2014_election_race) }
      it 'returns the updated at date of the most rencent news article' do
        most_recent_article = FactoryGirl.create(:news_article, moderation: 'approved')
        FactoryGirl.create(:news_mention,
                           person: electoral_race.candidacies.first.person,
                           news_article: most_recent_article)
        # Re-Fetched from AR so that timestamp is correct precision
        most_recent_article = NewsArticle.last
        timestamp = electoral_race.updated_at_including_news_articles
        expect(timestamp).to eq(most_recent_article.updated_at)
      end
    end
  end

  context 'when an electoral race has zero associated candidacies' do
    let(:electoral_race) { electoral_races(:point_douglas_2014_election_race) }

    describe '#updated_at_including_news_articles' do
      it 'returns the updated at timestamp of the ElectoralRace' do
        timestamp = electoral_race.updated_at_including_news_articles
        expect(timestamp).to eq(electoral_race.updated_at)
      end
    end
  end

  context 'when class is augmented with FriendlyURL concern' do
    it_behaves_like FriendlyURL do
      let(:object_of_described_class) do
        electoral_races(:friendly_url_electoral_race)
      end
      let(:test_slug) { 'test-slug-2014' }
    end

    let(:electoral_race) {
      electoral_races(:city_of_winnipeg_2014_election_race)
    }

    it 'returns a friendly url path' do
      regexp = %r{^/electoral_races/\d+/mayoral-city-of-winnipeg-2014$}
      expect(electoral_race.friendly_path).to match regexp
    end
  end

end
