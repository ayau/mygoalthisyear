module GoalsHelper
    
    def nested_goals(goals)  
        goals.map do |goal, sub_goals| 
            render(goal) + content_tag(:div, nested_goals(sub_goals), :class => "nested_goals")  
        end.join.html_safe  
    end

end
