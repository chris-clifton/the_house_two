# frozen_string_literal: true

# Application-wide helper module
module ApplicationHelper
  # Manage the active state of the nav elements and apply either the
  # active-nav-bar-element or the inactive-nav-bar-element depending
  # on the current page
  # https://dev.to/yarotheslav/highlight-link-to-current-page-tldr-2dj5
  #
  # @params TODO
  # @return [Rails link_to]
  def active_link_to(options)
    content_tag(:li) do
      active = current_page?(options[:path])
      active_class = active ? 'active-nav-bar-element' : 'inactive-nav-bar-element'
      li_inner_html = set_html(active, options[:text])

      link_to options[:path], class: active_class do
        li_inner_html.squish.html_safe
      end
    end
  end

  # Return either the avatar attached to the user, or the default gravatar
  # image for a user without an avatar. Unless a 'size' param is provided,
  # set a default of size 48.
  #
  # @param user [User]
  # @param opts[:size] [Integer]
  def avatar_url_for(user, opts = {})
    size = opts[:size] || 48

    if user.avatar.attached?
      user.avatar.variant(resize_to_fill: [size, nil])
    else
      "https://www.gravatar.com/avatar/00000000000000000000000000000000.png?s=#{size}}"
    end
  end

  # # The nested form helper 'fields_for' wont display the fields if a consequence
  # # doesnt already exist.  Since that wont ever be the case when we're creating a new
  # # assigned_chore, and thus a consequence, we need to instantiate a new Consequence
  # # for this form.
  # # https://www.sitepoint.com/complex-rails-forms-with-nested-attributes/
  # #
  # # @param assigned_chore [AssignedChore]
  # # @return [Consequence]
  # def setup_consequence_for_nested_form(assigned_chore)
  #   assigned_chore.consequence.present? ? assigned_chore.consequence : assigned_chore.build_consequence
  # end

  private

  # Take the active status and the nav_type and determine which HTML to
  # return (as a string) for the given nav element
  #
  # @params TODO
  # @return [String]
  def set_html(active, nav_type)
    case nav_type
    when 'Home'
      nav_menu_home_html(active)
    when 'Chores'
      nav_menu_chores_html(active)
    when 'Challenges'
      nav_menu_challenges_html(active)
    when 'Training'
      nav_menu_training_html(active)
    when 'Milestones'
      nav_menu_milestones_html(active)
    when 'Rewards'
      nav_menu_rewards_html(active)
    when 'Consequences'
      nav_menu_consequences_html(active)
    else
      'update set_mobile_html case statement'
    end
  end

  # Return a string containing the HTML we want inside the nav active_link_to
  # for the home link. Set the text color based on its active status.
  #
  # @params active [Boolean]
  # @return [String]
  def nav_menu_home_html(active)
    %(<svg class="#{active_text_color(active)} mr-4 flex-shrink-0 h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
      </svg>
      <span class="#{active_text_color(active)}">Home</span>)
  end

  # Return a string containing the HTML we want inside the nav active_link_to
  # for the chores link. Set the text color based on its active status.
  #
  # @params active [Boolean]
  # @return [String]
  def nav_menu_chores_html(active)
    %(<svg xmlns="http://www.w3.org/2000/svg" class="#{active_text_color(active)} mr-4 flex-shrink-0 h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
        <path stroke-linecap="round" stroke-linejoin="round" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4" />
      </svg>
      <span class="#{active_text_color(active)}">Chores</span>)
  end

  # Return a string containing the HTML we want inside the nav active_link_to
  # for the challenges link. Set the text color based on its active status.
  #
  # @params active [Boolean]
  # @return [String]
  def nav_menu_challenges_html(active)
    %(<svg xmlns="http://www.w3.org/2000/svg" class="#{active_text_color(active)} group-hover:text-gray-300 mr-4 flex-shrink-0 h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
        <path stroke-linecap="round" stroke-linejoin="round" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z" />
      </svg>
      <span class="#{active_text_color(active)}">Challenges</span>)
  end

  # Return a string containing the HTML we want inside the nav active_link_to
  # for the training link. Set the text color based on its active status.
  #
  # @params active [Boolean]
  # @return [String]
  def nav_menu_training_html(active)
    %(<svg xmlns="http://www.w3.org/2000/svg" class="#{active_text_color(active)} group-hover:text-gray-300 mr-4 flex-shrink-0 h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
        <path d="M12 14l9-5-9-5-9 5 9 5z" />
        <path d="M12 14l6.16-3.422a12.083 12.083 0 01.665 6.479A11.952 11.952 0 0012 20.055a11.952 11.952 0 00-6.824-2.998 12.078 12.078 0 01.665-6.479L12 14z" />
      <path stroke-linecap="round" stroke-linejoin="round" d="M12 14l9-5-9-5-9 5 9 5zm0 0l6.16-3.422a12.083 12.083 0 01.665 6.479A11.952 11.952 0 0012 20.055a11.952 11.952 0 00-6.824-2.998 12.078 12.078 0 01.665-6.479L12 14zm-4 6v-7.5l4-2.222" />
      </svg>
      <span class="#{active_text_color(active)}">Training</span>)
  end

  # Return a string containing the HTML we want inside the nav active_link_to
  # for the consequences link. Set the text color based on its active status.
  #
  # @params active [Boolean]
  # @return [String]
  def nav_menu_consequences_html(active)
    %(<svg xmlns="http://www.w3.org/2000/svg" class="#{active_text_color(active)} mr-4 flex-shrink-0 h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
        <path stroke-linecap="round" stroke-linejoin="round" d="M9.172 16.172a4 4 0 015.656 0M9 10h.01M15 10h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
      </svg>
      <span class="#{active_text_color(active)}">Consequences</span>)
  end

  # Return a string containing the HTML we want inside the nav active_link_to
  # for the trophy link. Set the text color based on its active status.
  #
  # @params active [Boolean]
  # @return [String]
  def nav_menu_milestones_html(active)
    %(<svg xmlns="http://www.w3.org/2000/svg" class="#{active_text_color(active)} ml-1 mr-4 flex-shrink-0 h-6 w-6" stroke="currentColor" stroke-width="24"
	      viewBox="0 0 502 502" style="enable-background:new 0 0 502 502;" xml:space="preserve">
          <path d="M492,58.458h-89.722c-2.205-7.839-4.907-15.553-8.105-23.122c-1.564-3.702-5.193-6.107-9.211-6.107H116.083
            c-4.019,0-7.647,2.405-9.211,6.107c-3.198,7.569-5.901,15.283-8.105,23.122H10c-5.523,0-10,4.478-10,10
            c0,40.449,13.161,78.557,37.058,107.303c23.517,28.288,54.671,44.294,88.058,45.347c0.905,1.334,1.821,2.662,2.762,3.978
            c21.895,30.639,51.617,54.018,86.281,67.946v23.333h-12.447c-5.523,0-10,4.478-10,10c0,5.522,4.477,10,10,10h12.447v17.826
            h-12.447c-5.523,0-10,4.478-10,10c0,5.522,4.477,10,10,10h12.447v23.558h-26.107c-29.848,0-54.131,24.283-54.131,54.131v10.89
            c0,5.522,4.477,10,10,10h213.204c5.523,0,10-4.478,10-10v-10.89c0-29.848-24.283-54.131-54.131-54.131h-26.107v-23.558h13.402
            c5.523,0,10-4.478,10-10c0-5.522-4.477-10-10-10h-13.402v-17.826h13.402c5.523,0,10-4.478,10-10c0-5.522-4.477-10-10-10h-13.402
            v-23.333c34.664-13.929,64.386-37.308,86.281-67.946c23.792-33.293,36.368-72.591,36.368-113.644
            c0-11.151-0.935-22.163-2.771-32.984h74.922c-2.949,46.85-26.431,89.208-61.505,109.752c-4.766,2.792-6.366,8.918-3.575,13.683
            c1.861,3.178,5.204,4.948,8.638,4.948c1.717,0,3.457-0.443,5.045-1.373c21.317-12.486,39.293-31.729,51.984-55.649
            C495.179,125.496,502,97.362,502,68.458C502,62.937,497.523,58.458,492,58.458z M20.305,78.458H94.28
            c-1.837,10.822-2.771,21.833-2.771,32.984c0,31.035,7.192,61.064,20.979,88.257C62.861,190.626,24.1,140.404,20.305,78.458z
            M312.993,417.749c18.82,0,34.131,15.311,34.131,34.131v0.89H153.92v-0.89c0-18.82,15.311-34.131,34.131-34.131H312.993z
            M266.886,374.191v23.558h-32.728v-23.558H266.886z M234.158,354.191v-17.826h32.728v17.826H234.158z M273.492,276.738
            c-3.964,1.431-6.605,5.192-6.605,9.406v30.221h-32.728v-30.221c0-4.214-2.642-7.976-6.605-9.406
            c-69.409-25.05-116.043-91.478-116.043-165.296c0-13.205,1.447-26.189,4.307-38.847c0.519-1.139,0.827-2.391,0.883-3.711
            c1.657-6.652,3.703-13.21,6.148-19.656H378.2c7.526,19.845,11.337,40.74,11.337,62.214
            C389.535,185.261,342.901,251.688,273.492,276.738z"/>
          <path d="M208.456,226.11c-21.505-11.884-39.218-32.593-49.875-58.313c-2.113-5.102-7.965-7.525-13.066-5.41
            c-5.103,2.114-7.525,7.964-5.411,13.066c12.384,29.889,33.223,54.096,58.678,68.163c1.534,0.847,3.192,1.249,4.828,1.249
            c3.521,0,6.938-1.864,8.761-5.165C215.043,234.866,213.29,228.783,208.456,226.11z"/>
          <path d="M141.488,148.237c5.445-0.925,9.109-6.089,8.184-11.533c-1.428-8.402-2.151-17.053-2.151-25.712c0-5.522-4.477-10-10-10
            c-5.523,0-10,4.478-10,10c0,9.778,0.819,19.556,2.434,29.062c0.829,4.878,5.06,8.327,9.847,8.327
            C140.357,148.382,140.921,148.335,141.488,148.237z"/>
      </svg>
      <span class="#{active_text_color(active)} ml-1">Milestones</span>)
  end

  # Return a string containing the HTML we want inside the nav active_link_to
  # for the rewards link. Set the text color based on its active status.
  #
  # @params active [Boolean]
  # @return [String]
  def nav_menu_rewards_html(active)
    %(<svg xmlns="http://www.w3.org/2000/svg" class="#{active_text_color(active)} mr-4 flex-shrink-0 h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
        <path stroke-linecap="round" stroke-linejoin="round" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
      </svg>
      <span class="#{active_text_color(active)}">Rewards</span>)
  end

  # Change the text color depending on the active state
  #
  # @params active [Boolean]
  # @return [String]
  def active_text_color(active)
    active ? 'text-gray-300' : 'text-gray-400'
  end
end
