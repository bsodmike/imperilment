require 'spec_helper'

describe LeaderBoardsController do
  authorize_and_login

  let!(:game) { create :game, locked: true }
  let(:user) { create :user }

  describe 'GET index' do
    let(:game_results) { [GameResult.new] }
    before(:each) do
      GameResult.stub(:all_results) { game_results }
    end

    context 'html' do
      it 'should assign the results to @results' do
        get :index
        assigns(:results).should == game_results
      end
    end
    context 'json' do
      it 'should assign the results to @results' do
        get :index, format: :json
        assigns(:results).should == game_results
      end
    end
  end

  describe 'GET show' do
    context "games dont exist" do
      it 'shouldnt fail miserably with an exception' do
        Game.destroy_all
        get :show
        assigns(:game).should be_nil
      end
    end
    context "games exist" do
      before(:each) do
        Game.any_instance.stub(:grouped_and_sorted_by_score) { {0 => [user]} }
        get :show
      end

      it 'should assign the game to @game' do
        assigns(:game).should == game
      end

      it 'should assign the users to @users' do
        assigns(:results).first.should be_a(GameResult)
        assigns(:results).first.user.should == user
      end

      context 'when a game_id is passed' do
        let(:other_game) { create :game }
        before(:each) do
          User.stub(:grouped_and_sorted_by_score).with(other_game)
          get :show, game_id: other_game
        end
        it 'should assign the game to @game' do
          assigns(:game).should == other_game
        end
      end
    end
  end

  describe "GET money" do
    let(:game_results) { [GameResult.new] }
    before(:each) do
      GameResult.stub(:all_results_by_money) { game_results }
    end

    it 'should assign the results to @results' do
      get :money
      assigns(:results).should == game_results
    end

    it 'should respond to html' do
      get :money
      response.should be_success
    end

    it 'should respond to json' do
      get :money, format: :json
      response.should be_success
    end
  end
end




