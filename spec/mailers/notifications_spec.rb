require "rails_helper"
 
describe NotificationsMailer do
  context "pending cards" do
    let!(:user) { create(:user) }
    let!(:mail) { NotificationsMailer.pending_cards(user) }
 
    it "renders the subject" do
      expect(mail.subject).to eql("У Вас есть непроверенные карточки")
    end
 
    it "send a letter to receiver email" do
      expect(mail.to).to eql([user.email])
    end
 
    it "send a letter from no-reply@my-flashcards.com" do
      expect(mail.from).to eql(["no-reply@my-flashcards.com"])
    end
 
    it "renders the review_card url" do
      expect(mail.body.encoded).to match(new_review_url)
    end
  end
end
