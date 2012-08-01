require 'the_blob'
require 'interfaces/session_interface'

class Subj; include SessionInterface; include TheBlob; end

describe SessionInterface do

  let(:subj_class) { Class.new }
  let(:subject) { subj_class.new }

  let(:params) { { email: double,
                   password: "pass",
                   password_confirmation: "pass" } }

  before(:each) do
    @dir = File.expand_path("../../../lib/test_instances", __FILE__)
    File.stub!(:expand_path) {@dir}
    subj_class.class_eval { include SessionInterface }
    subj_class.class_eval { include TheBlob }
  end

  describe '#create_user' do
    it 'raises BadPasswordConfirmation if pass and conf dont match' do
      params[:password] = 'derp'
      expect{ subject.create_user(params) }.to raise_error(BadPasswordConfirmation)
    end
    it 'raises BadPassword if passwords are empty' do
      params = {password: '', password_confirmation: ''}
      expect{ subject.create_user(params) }.to raise_error(BadPassword)
    end
    it 'encrypts a users password' do
      subject.create_user(params)
      user = subject.fetch_user params[:email]
      subject.password_matches?(user, params[:password]).should be_true
    end
  end

  describe '#fetch_user' do
    it 'returns a user when given an email' do
      subject.create_user params
      user = subject.fetch_user( params[:email] )
      user.email.should be(params[:email])
    end

    it 'raises NoUserFound if email doesnt match anything' do
      expect{ subject.fetch_user(params[:email]) }.to raise_error(NoUserFound)
    end
  end

  describe '#password_matches' do
    it 'returns true if given the correct password' do
      subject.create_user params
      user = subject.fetch_user( params[:email] )
      subject.password_matches?(user, params[:password]).should be_true
    end
    it 'raises WrongPassword if password doesnt match' do
      subject.create_user params
      user = subject.fetch_user( params[:email] )
      expect{subject.password_matches?(user, "herp")}.to raise_error(WrongPassword)
    end
  end
end
