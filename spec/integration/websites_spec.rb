require "spec_helper"

describe "Integration '/:id'", auth_request: true, integration: true, js: true, vcr: VCR_OPTIONS do
  describe "Lists all web templates" do
    before do
      @client, @location, @website = seed
      @web_home_template = @website.web_home_template
      @web_page_template = @website.web_page_templates.first
      visit "/#{@website.slug}"
    end
    it "displays the website menu" do
      within TOP_NAV do
        page.should have_content "DEPLOY"
        page.should have_content "REDIRECTS MANAGER"
        page.should have_content "ASSET MANAGER"
      end
    end

    it "Displays client, location, and page names" do
      within ".breadcrumb" do
        page.should have_content @client.name
        page.should have_content @location.name
      end

      within WEB_HOME_SELECTOR do
        page.should have_content @web_home_template.name.upcase
      end

      within WEB_PAGE_SELECTOR do
        page.should have_content @web_page_template.name.upcase
      end
    end

    it "Home 'Edit' link goes to '/:website_slug/:home_slug'" do
      within WEB_HOME_SELECTOR do
        find(:link, 'Edit').trigger('click')
      end

      current_path.should eq "/#{@web_home_template.website.slug}/#{@web_home_template.slug}"
    end

    it "Page 'Edit' link goes to '/:website_slug/:page_slug'" do
      within WEB_PAGE_SELECTOR do
        find(:link, 'Edit').trigger('click')
      end

      current_path.should eq "/#{@website.slug}/#{@web_page_template.slug}"
    end

    it "'create new page' link goes to '/:website_slug/webPageTemplates/new'" do
      click_link "Create New Page"

      current_path.should eq "/#{@website.slug}/webPageTemplates/new"
    end

  end

  describe "Web page templates have settings" do
    before do
      @client, @location, @website = seed
      @web_home_template = @website.web_home_template
      @web_page_template = @website.web_page_templates.first
      visit "/#{@website.slug}"
    end

    it "clicking on the gear should flip page card to reveal settings" do
      within WEB_PAGE_SELECTOR do
        click_link "Page Settings"
        sleep 1
      end
      expect(page).to have_css(".web-page-template.flipped:first-of-type")
      expect(page).to have_content("PAGE NAME (FOR CMS)")
      expect(page).to have_content("PAGE TITLE")
    end

    it "can update web page template name" do
      within WEB_PAGE_SELECTOR do
        click_link "Page Settings"
        fill_in "page_name", with: "Hakuna Matata"
        page.execute_script('$(".save").click()')
        expect(page).to have_content("HAKUNA MATATA")
      end
    end

    it "can update web page template title" do
      within WEB_PAGE_SELECTOR do
        click_link "Page Settings"
        fill_in "page_title", with: "No Worries"
        page.execute_script('$(".save").click()')
        visit current_path
      end
      expect(@web_page_template.reload.title).to eq("No Worries")
    end

    it "can update web page template title with liquid variables" do
      within WEB_PAGE_SELECTOR do
        click_link "Page Settings"
        fill_in "page_title", with: "{{ location_name }}"
        page.execute_script('$(".save").click()')
        visit current_path
      end
      expect(@web_page_template.reload.title).to eq("{{ location_name }}")
    end
  end

  describe "Web page templates are drag and drop sortable" do
    before do
      pending("Drag and drop specs fail intermittently.")
      @client, @location, @website = seed
      @web_page_template1 = @website.web_page_templates.first
      @web_page_template2 = @website.web_page_templates.last

      # Make sure widgets are ordered first and last
      @web_page_template1.update_attribute :display_order, :first
      @web_page_template2.update_attribute :display_order, :last

      visit "/#{@website.slug}"
    end

    it "Updates database" do
      within ".web-page-templates" do
        web_page_template1 = ".web-page-template:first-of-type"
        web_page_template2 = ".web-page-template:last-of-type"
        expect(@web_page_template2.display_order > @web_page_template1.display_order).to be_truthy
        drag_and_drop(web_page_template1, web_page_template2)
        sleep 1
        expect(@web_page_template2.reload.display_order < @web_page_template1.reload.display_order).to be_truthy
      end
    end
  end

  describe "Web page templates can be dragged to the trash" do
    before do
      pending("Drag and drop specs fail intermittently.")
      @client, @location, @website = seed
      visit "/#{@website.slug}"
    end

    it "Updates database" do
      web_page_template = ".web-page-templates .web-page-template:first-of-type"
      trash = ".web-page-templates-in-trash"
      expect do
        drag_and_drop(web_page_template, trash)
        sleep 1
      end.to change{ WebPageTemplate.where(in_trash: true).count }.by(1)
    end
  end

  describe "Web page templates can be dragged out of the trash" do
    before do
      pending("Drag and drop specs fail intermittently.")
      @client, @location, @website = seed
      @website.web_page_templates.first.update_attribute(:in_trash, true)
      visit "/#{@website.slug}"
    end

    it "Updates database" do
      pending("Drag and drop specs fail intermittently.")
      web_page_template = ".web-page-templates-in-trash .web-page-template:first-of-type"
      not_trash = ".web-page-templates"
      expect do
        drag_and_drop(web_page_template, not_trash)
        sleep 1
      end.to change{ WebPageTemplate.trash.count }.by(-1)
    end
  end

  describe "Clicking on the trash can brings up a confirmation to empty the trash" do
    before do
      @client, @location, @website = seed
      @website.web_page_templates.first.update_attribute(:in_trash, true)
      visit "/#{@website.slug}"
      within "#trash" do
        find(".icon--trash").click
      end
    end

    it "Does nothing if cancel is clicked" do
      expect do
        within ".empty-trash" do
          click_link "empty-trash-cancel"
          sleep 1
        end
      end.not_to change { WebPageTemplate.count }
    end
  end
end
