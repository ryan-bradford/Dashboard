require 'spec_helper.rb'
require_job 'build_health.rb'

describe 'get build data from travis' do
  before(:each) do
    @travis_response = [
      {
        "result" => 0,
        "duration" => 12345,
        "id" => 54321,
        "started_at" => 4444444
      }
    ]
    stub_request(:get, 'https://api.travis-ci.org/repos/myrepo/mybuild/builds?event_type=push').
         to_return(:status => 200, :body => @travis_response.to_json, :headers => {})
  end

  it 'should get travis build info from travis api' do
    build_health = get_build_health 'id' => 'myrepo/mybuild', 'server' => 'Travis'
    expect(WebMock.a_request(:get, 'https://api.travis-ci.org/repos/myrepo/mybuild/builds?event_type=push')).to have_been_made
  end

  it 'should return the name of the build' do
    build_health = get_build_health 'id' => 'myrepo/mybuild', 'server' => 'Travis'
    expect(build_health[:name]).to eq('myrepo/mybuild')
  end

  it 'should return the status of the latest build when Successful' do
    build_health = get_build_health 'id' => 'myrepo/mybuild', 'server' => 'Travis'
    expect(build_health[:status]).to eq('Successful')
  end

  it 'should return the status of the latest build when Failed' do
    failed_build = [{"result" => 1}]
    stub_request(:get, "https://api.travis-ci.org/repos/myrepo/mybuild/builds?event_type=push").
         to_return(:status => 200, :body => failed_build.to_json, :headers => {})
    build_health = get_build_health 'id' => 'myrepo/mybuild', 'server' => 'Travis'
    expect(build_health[:status]).to eq('Failed')
  end

  it 'should return the duration of the latest build' do
    build_health = get_build_health 'id' => 'myrepo/mybuild', 'server' => 'Travis'
    expect(build_health[:duration]).to eq(12345)
  end

  it 'should return a link to the latest build' do
    build_health = get_build_health 'id' => 'myrepo/mybuild', 'server' => 'Travis'
    expect(build_health[:link]).to eq('https://travis-ci.org/myrepo/mybuild/builds/54321')
  end

  it 'should return the time of the latest build' do
    build_health = get_build_health 'id' => 'myrepo/mybuild', 'server' => 'Travis'
    expect(build_health[:time]).to eq(4444444)
  end

  it 'should return the build health' do
    so_so = [{"result" => 1}, {"result" => 0}]
    stub_request(:get, 'https://api.travis-ci.org/repos/myrepo/mybuild/builds?event_type=push').
         to_return(:status => 200, :body => so_so.to_json, :headers => {})
    build_health = get_build_health 'id' => 'myrepo/mybuild', 'server' => 'Travis'
    expect(build_health[:health]).to eq(50)
  end
end
