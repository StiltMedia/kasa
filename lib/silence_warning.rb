
# silences the
# warn('Cookie#domain returns dot-less domain name now. Use Cookie#dot_domain if you need "." at the beginning.')
# emitted by the httpclient gem
class WebAgent
  class Cookie < HTTP::Cookie
  private
    def domain_warning
    end
  end
end

