require 'rails_helper'
RSpec.describe 'ユーザー管理機能', type: :system do

  # let(:user) {FactoryBot.create(:user)}
  # let(:user2) {FactoryBot.create(:user2)}
  before do
    FactoryBot.create(:user)
    FactoryBot.create(:user2)
  end

  describe 'ユーザー新規作成' do

    context 'ユーザーを新規作成した場合' do

      it '作成したユーザーが表示される' do
        visit new_user_path
        expect(new_user_path).to eq new_user_path
        fill_in 'user[name]', with: 'takuya1'
        fill_in 'user[email]', with: 'taku1@docomo.ne.jp'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]',with: 'password'
        click_on 'アカウント作成'
        expect(page).to have_content 'takuya1'

      end
    end

    context 'ログインせずに一覧ページに飛んだ場合' do
      it '遷移せずログインページに戻されること' do
        visit tasks_path(3)
        expect(page).to have_content "ログイン"
        expect(current_path).to have_content "/sessions/new"
      end
    end

  end

  describe 'ログイン機能' do

    context 'ログインした場合' do
      it 'ログインができること' do
        visit new_session_path
        expect(current_path).to have_content "/sessions/new"
        fill_in 'session[email]', with: 'testuser01@docomo.ne.jp'
        fill_in 'session[password]', with: 'password'

        click_button 'log_in'
        expect(page).to have_content "testuser01としてログイン中"

      end
    end

    context 'ログアウトした場合' do 
      it 'ログアウトができること' do
        visit new_session_path
        expect(current_path).to have_content "/sessions/new"
        fill_in 'session[email]', with: 'testuser01@docomo.ne.jp'
        fill_in 'session[password]', with: 'password'
        click_on 'log_in'
        expect(page).to have_content "testuser01としてログイン中"
        click_on 'logout'
        expect(page).to have_content 'ログアウトしました。'
      end
    end

  end

  describe 'ユーザー詳細機能' do
    context '自分の詳細ページボタンを押した場合' do 
      it '自分の詳細ページに遷移すること' do
        visit new_user_path
        visit new_session_path
        expect(current_path).to have_content "/sessions/new"
        fill_in 'session[email]', with: 'testuser01@docomo.ne.jp'
        fill_in 'session[password]', with: 'password'
        click_button 'log_in'
        expect(page).to have_content 'ユーザー編集'
      end
    end
  end

  describe '管理画面テスト' do

    context '管理者が管理画面にアクセスした場合' do

      context '一般ユーザーがアクセスした場合' do
        it '一般ユーザーが入れないこと' do
          visit new_session_path
          fill_in 'session[email]',with: 'testuser01@docomo.ne.jp'
          fill_in 'session[password]',with: 'password'
          click_button 'log_in'
          expect(page).to have_content 'testuser01'
        end
      end

      it '管理画面に遷移されること' do
        visit new_session_path
        fill_in 'session[email]', with: 'admin01@docomo.ne.jp'
        fill_in 'session[password]', with: 'password'
        click_on 'log_in'
        expect(current_path).to have_content "/admin/users"
      end

      it '管理者は新規ユーザーを作成できること' do
        visit new_session_path
        fill_in 'session[email]', with: 'admin01@docomo.ne.jp'
        fill_in 'session[password]', with: 'password'
        click_on 'log_in'
        click_on 'admin_user_create'
        fill_in 'user[name]', with: 'testuser11'
        fill_in 'user[email]', with: 'testuser11@docomo.ne.jp'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_on '登録する'
        expect(current_path).to have_content "/admin/users"
      end
    end

    context '管理者が管理画面にアクセスした場合' do
      it '管理ユーザーは他人の詳細ページが確認できること' do
        visit new_session_path
        fill_in 'session[email]',with: 'admin01@docomo.ne.jp'
        fill_in 'session[password]',with: 'password'
        click_button 'log_in'
        
        chk_user = User.find_by(email: 'testuser01@docomo.ne.jp')
        expect(page).to have_link 'users_admin_show', href: admin_user_path(chk_user)
        #first('tbody tr').click_link 'users_admin_show'
        #first('tr td:nth-child(4)').click
        
        # click_link 'users_admin_show', href: admin_user_path(chk_user)
        expect(page).to have_content 'testuser01'
      end
    end

    context '管理者が管理画面にアクセスした場合' do
      it '管理ユーザーはユーザの編集画面からユーザを編集できること' do
        visit new_session_path
        fill_in 'session[email]',with: 'admin01@docomo.ne.jp'
        fill_in 'session[password]',with: 'password'
        click_button 'log_in'
        visit admin_users_path

        all('tr td')[12].click_link # 特定のUserの編集画面に移動する
        fill_in 'user[name]', with: 'rspec_user'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_on '更新する'
        expect(page).to have_content "rspec_user"
      end
    end

    context '管理者が管理画面にアクセスした場合' do
      it '管理者は他のユーザーを消去できる' do
        visit new_session_path
        fill_in 'session[email]', with: 'admin01@docomo.ne.jp'
        fill_in 'session[password]', with: 'password'
        click_button 'log_in'
       
        visit admin_users_path
        expect(page).to have_content('testuser01')

        all('tr td')[6].click_link
        page.accept_confirm '削除してよろしいですか？'
        sleep 2
        expect(page).not_to have_content('testuser01')
      end
    end
  end
end