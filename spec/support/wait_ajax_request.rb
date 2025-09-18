module WaitAjaxRequest
  def wait_ajax_request
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until ajax_requests_finished?
      sleep 1
    end
  end

  def ajax_requests_finished?
    page.evaluate_script('jQuery.active').zero?
  end
end
