class PurchaseController < ApplicationController
  require 'payjp'

  def index
    card = Card.where(user_id: current_user.id).first
    #テーブルからpayjpの顧客IDを検索
    if card.blank?
      #登録された情報がない場合にカード登録画面に移動
      redirect_to controller: "card", action: "new"
    else
      # Payjp.api_key = Rails.application.credentials.PAYJP_PRIVATE_KEY
      Payjp.api_key = "sk_test_8a22f3d6cc423679a2d3e948"
      #保管した顧客IDでpayjpから情報取得
      customer = Payjp::Customer.retrieve(card.customer_id)
      #保管したカードIDでpayjpから情報取得、カード情報表示のためインスタンス変数に代入
      @default_card_information = customer.cards.retrieve(card.card_id)
      @card_brand = card_brand
    end
    @product = Product.all
  end

  def pay
    card = Card.where(user_id: current_user.id).first
    # Payjp.api_key = Rails.application.credentials.PAYJP_PRIVATE_KEY
    Payjp.api_key = "sk_test_8a22f3d6cc423679a2d3e948"
    Payjp::Charge.create(
    :amount => 135000, #支払金額を入力（itemテーブル等に紐づけても良い）
    :customer => card.customer_id, #顧客ID
    :currency => 'jpy', #日本円
    )
    redirect_to action: 'done' #完了画面に移動
  end

  def done
    card = Card.where(user_id: current_user.id).first
    customer = Payjp::Customer.retrieve(card.customer_id)
    @default_card_information = customer.cards.retrieve(card.card_id)
    @card_brand = card_brand
  end

  def update
    product = Product.find(params[:id])
  end

  def card_brand
    case @default_card_information.brand
    when "Visa"
      @card_src = "visa.svg"
    when "JCB"
      @card_src = "jcb.svg"
    when "MasterCard"
      @card_src = "master-card.svg"
    when "American Express"
      @card_src = "american_express.svg"
    when "Diners Club"
      @card_src = "dinersclub.svg"
    when "Discover"
      @card_src = "discover.svg"
    end
  end
end
