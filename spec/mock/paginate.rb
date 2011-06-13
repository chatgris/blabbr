# encoding: utf-8
def mock_paginate(paginable)
  mock = mock(paginable)
  mock.stub!(:each).and_return(mock)
  mock.stub!(:page).and_return(mock)
  mock.stub!(:per).and_return(mock)
  mock.stub!(:current_page).and_return(rand(100))
  mock.stub!(:num_pages).and_return(rand(100))
  mock.stub!(:total_count).and_return(100)
  mock.stub!(:limit_value).and_return(rand(10))
  mock.stub!(:any?).and_return(true)
  mock.stub!(:to_json).and_return(mock.as_json)
  mock.stub!(:as_json).and_return({})
  mock
end
