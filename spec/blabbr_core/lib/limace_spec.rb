# encoding: utf-8
require 'spec_helper'

describe BlabbrCore::Limace do
  let(:topic) { Factory :topic }

  describe 'limace creation' do
    context 'on creation' do
      it 'should have a limace' do
        topic.reload.limace.should eq topic.title.parameterize
      end

      it 'should fallback on title when parameterize is nil' do
        topic = Factory :topic, title: 'でも、でも。。。'
        topic.reload.limace.should eq topic.title
      end
    end

    context 'on update' do
      it 'should update limace' do
        topic.title = "I want a new limace"
        topic.save
        topic.reload.limace.should eq topic.title.parameterize
      end

      it 'should fallback on title when parameterize is nil' do
        topic.title = 'でも、でも。。。'
        topic.save
        topic.reload.limace.should eq topic.title
      end
    end
  end
end
