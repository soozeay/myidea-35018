require 'rails_helper'

RSpec.describe "IdeasApi", type: :request do
  before do
    @category_idea = FactoryBot.build(:category_idea)
    @another_one = FactoryBot.build(:category_idea)
  end

  describe "GET /ideas_apis" do
    context '取得できる時' do
      it "取得する" do
        expect(@category_idea).to be_valid
        @category_idea.save
        get '/api/v1/ideas'
        json = JSON.parse(response.body)
        # ステータスが200であることを確認する
        expect(response.status).to eq(200)
        expect(json.length).to eq(1)
      end
      it '特定のデータのみ取得する(category_name: ”これはテストです”とする)' do
        @category_idea.save
        @another_one.category_name= "これはテストです"
        @another_one.save
        get '/api/v1/ideas'
        # 特定のデータのみ取得する
        get "/api/v1/ideas", params: { category_name: "これはテストです" }
        expect(response.status).to eq(200)
        json = JSON.parse(response.body)
        # 指定したideaが返却されているか確認する
        expect(json[0]["category_name"]).to eq(@another_one.category_name)
      end
      it 'リクエストが空欄ではideaを全て取得する' do
        @category_idea.save
        @another_one.save
        # パラメータにcategory_nameを指定しない
        get '/api/v1/ideas'
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        # リクエスト全て取得するとjsonは2つ存在する
        expect(json.length).to eq(2)
      end
    end
    context '取得出来ない時' do
      it '存在しないcategory_nameをリクエストするとステータス404が返却される' do
        @category_idea.save
        # FactoryBotとはまた別のcategory_nameを送信
        get "/api/v1/ideas", params: { category_name: "存在しない" }
        json = JSON.parse(response.body)
        expect(response.status).to eq(404)
      end
      it 'リクエストのキーがcategory_name以外では絞った表示ができず、全て返却されてしまう' do
        @category_idea.category_name = "テスト"
        @category_idea.save
        @another_one.save
        get "/api/v1/ideas", params: { hoge: "テスト" }
        json = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json.length).to eq(2)
      end
    end
  end

  describe "POST /ideas_apis" do
    context "登録できるとき" do
      it '正しくリクエストを送信すれば登録できる' do
        post "/api/v1/ideas", params: { category_name: @category_idea.category_name, body: @category_idea.body }
        json = JSON.parse(response.body)
        expect(response.status).to eq(201)
      end
      it '同じcategoryでアイデアを登録する時、categoriesテーブルのレコードは1つしか増えていない事を確認する' do
        @category_idea.category_name = "重複テストをします"
        # 1つ目の登録でCategoryが1つカウントされている事を確認
        expect{
          post "/api/v1/ideas", params: { category_name: @category_idea.category_name, body: @category_idea.body }
        }.to change { Category.count }.by(1)
        # もう一つのideaを生成するが、categoriesテーブルのカウントは増えない
        @another_one.category_name = "重複テストをします"
        expect{
          post "/api/v1/ideas", params: { category_name: @another_one.category_name, body: @another_one.body }
        }.to change { Category.count }.by(0)
      end
    end
    context '登録できないとき' do
      it 'category_nameが空では登録できない' do
        @category_idea.category_name = ""
        post "/api/v1/ideas", params: { category_name: @category_idea.category_name, body: @category_idea.body }
        json = JSON.parse(response.body)
        expect(response.status).to eq(422)
      end
      it 'bodyが空では登録できない' do
        @category_idea.body = ""
        post "/api/v1/ideas", params: { category_name: @category_idea.category_name, body: @category_idea.body }
        json = JSON.parse(response.body)
        expect(response.status).to eq(422)
      end
    end
  end
end