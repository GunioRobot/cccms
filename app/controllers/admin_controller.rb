class AdminController < ApplicationController
  before_filter :login_required

  def index
    @drafts = Page.drafts
    @recent_changes = Node.all(
      :limit => 50,
      :order => "updated_at desc",
      :conditions => [ 
        "updated_at < ? AND updated_at > ?", Time.now, Time.now-14.days
      ]
    )
  end
  
  def search
    @results = Node.search params[:search_term]
    
    respond_to do |format|
      format.html
      format.js do 
        render( :json => @results.map do |node| 
          {:id => node.id, :title => node.title, :edit_path => node_path(node)} 
          end
        )
        
      end 
    end
  end
  
end
