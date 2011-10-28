# -*- encoding: UTF-8 -*-
require File.dirname(__FILE__) + '/../querybuilder'

describe QueryBuilder do
  before(:each) do
    @builder = QueryBuilder.new
  end

  it 'can set select' do
    @builder.select('*').attribute('column').should == '*'
  end

  it 'can set table' do
    @builder.select('*').from('foo').attribute('table').should == 'foo'
  end

  it 'can set where' do
    query = @builder.select('*').from('foo').where('a', '=', 100)
    query.attribute('where')['key'].should == 'a'
  end

  it 'can set limit' do
    query = @builder.limit(0, 50)
    query.attribute('limit').should == 'LIMIT 0, 50'
    query.limit(50)
    query.attribute('limit').should == 'LIMIT 50'
  end

  it 'can set order' do
    query = @builder.order('foo', 'DESC')
    query.attribute('order').should == 'ORDER BY foo DESC'
  end

  it 'can set update columns' do
    query = @builder.set('foo', '1').set('bar', '2')
    query.attribute('set')[1]['key'].should == 'bar'    
  end

  it 'can build select query' do
    expected = 'SELECT * FROM foo WHERE a = 100 AND b > 1 ORDER BY c DESC LIMIT 0, 50'
    query = @builder.select('*').from('foo').where('a', '=', 100).and('b', '>', 1)
    query.limit(0, 50).order('c', 'DESC')
    query.build.should == expected
  end

  it 'can build update query' do
    expected = 'UPDATE foo SET piyo = "x", hoge = "y" WHERE a = 100 AND b > 1 ORDER BY c DESC LIMIT 0, 50'
    query = @builder.update('foo').set('piyo', 'x').set('hoge', 'y').where('a', '=', 100).and('b', '>', 1)
    query.limit(0, 50).order('c', 'DESC')
    query.build.should == expected
  end

  it 'can build update delete' do
    expected = 'DELETE FROM foo WHERE a = 100 OR b > 1 ORDER BY c DESC LIMIT 0, 50'
    query = @builder.delete('foo').where('a', '=', 100).or('b', '>', 1)
    query.limit(0, 50).order('c', 'DESC')
    query.build.should == expected
  end
end
