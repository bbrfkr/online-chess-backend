FROM ruby:3.3.0
COPY Gemfile Gemfile.lock .
RUN bundle install
COPY . /src
WORKDIR /src
ENTRYPOINT ["rails"]
CMD ["s", "-b", "0.0.0.0", "-p", "8080"]
