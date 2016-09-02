require 'spec_helper.rb'
require 'httparty'
require 'watir-webdriver'
require 'pry'

describe "Tumblr Tests" do

	it "Should log in with valid username and password on tumblr" do
	 	@browser = Watir::Browser.new :chrome
	 	@browser.goto "http://tumblr.com/login"
		@browser.text_field(:id => "signup_determine_email").set "abcd1234_1234abcz@test.com\n"
		@browser.text_field(:id => 'signup_password').when_present.set("abcd1234\n") 
	 	@browser.quit
	end
	it "should log in with invalid format o tumblr" do
	 	browser = Watir::Browser.new :chrome
	 	browser.goto "http://tumblr.com/login"
	 	browser.text_field(:id => "signup_determine_email").set "abcd1234_1234abcz\n"
	 	sleep 1
	 	p = browser.li(:class => "error").text
	 	expect(p).to eq "That's not a valid email address. Please try again."
	 	browser.quit
	end
	it "Should log in with a valid format that not signed up on tumblr" do
	 	browser = Watir::Browser.new :chrome
	 	browser.goto "http://tumblr.com/login"
	 	browser.text_field(:id => "signup_determine_email").set "qsdadae@gmail.com\n"
	 	sleep 1
	 	p = browser.li(:class => "error").text
	 	expect(p).to eq "This email doesn't have a Tumblr account. Sign up now?"
	 	browser.quit
	end
	it "Should log in with correct username worng password on tumblr" do
	 	browser = Watir::Browser.new :chrome
	 	browser.goto "http://tumblr.com/login"
		browser.text_field(:id => "signup_determine_email").set "abcd1234_1234abcz@test.com\n"
	 	browser.text_field(:id => 'signup_password').when_present.set("aewsfvgsdfgw4\n") 
	 	sleep 1
	 	p = browser.li(:class => "error").text
	 	expect(p).to eq "Your email or password were incorrect."
	 	browser.quit
	end
	it "Should log in and make a post on tumblr" do
		browser = Watir::Browser.new :chrome
		browser.goto "http://tumblr.com/login"
		browser.text_field(:id => "signup_determine_email").set "abcd1234_1234abcz@test.com\n"
		browser.text_field(:id => 'signup_password').when_present.set("abcd1234\n") 
		browser.button(:class, 'compose-button').when_present.click
		browser.div(:class,"post-type-icon icon-text").when_present.click
		browser.div(class: "editor editor-plaintext").when_present.send_keys("Me irl")
		browser.div(:class,"editor editor-richtext").send_keys "Banter Bus!"
		browser.button(:class,"button-area create_post_button").click
		p=browser.lis(class: /post_container$/).first.div(class: 'post_body').text
		expect(p).to eq "Banter Bus!" 
		browser.quit
	end
end

describe "Amazon Tests" do
	it "Should be able to buy a book in amazon" do
		browser = Watir::Browser.new :chrome
		browser.goto "http://amazon.co.uk"
		browser.text_field(:id => "twotabsearchtextbox").set "Object Oriented Programming\n"
		browser.link(:title =>"Object Oriented Programming: Questions and Answers").click
		expect(browser.span(class: "a-color-price").text).to eq "£10.30"
		browser.quit
	end
	it "should be able to return the search results" do
		list=[]
		list2=[]
		browser = Watir::Browser.new :chrome
		browser.goto "http://amazon.co.uk"
		browser.text_field(:id => "twotabsearchtextbox").set "Object Oriented Programming: Questions and Answers\n"
		sleep 1
		results = browser.ul(:id => "s-results-list-atf")
		results.lis.each do |e| 
			list.push(browser.li(:id=> e.id).h2.text)
			list2.push(browser.li(:id=> e.id).span(:class=>"a-size-base a-color-price s-price a-text-bold").text)
		end
		File.open("book.txt", "w") do |file|
			file.write("Object Oriented Programming Books\n\n")
			list.each_with_index do |item, index|
				file.write("#{item}: ")
				file.write("#{list2[index]}")
				file.write("\n")
			end
		end
		browser.quit
	end
end	