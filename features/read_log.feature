Feature: Read a log file, parse it and then store it in the DB
  As a developer,
  In order to facilitate analysis of information in a log file,
  I want to read a plain-text log file and have its contents parsed and stored in a database.

  Background:
    Given a file named "sample.log" with:
    """
    5.5.5.5 10.10.10.10 [01/Sept/2011:18:00:00 +0000] "GET /page1 HTTP/1.1"
    8.8.8.8 10.10.10.10 [01/Sept/2011:18:00:30 +0000] "GET /page2 HTTP/1.1"
    """
    And a file named "format.yml" with:
    """
    - http_x_forwarded_for
    - remote_addr
    - date
    - request
    """

  Scenario: Read a log file
    When I run `herdsman read --format format.yml --source sample.log`
    Then the output should contain:
    """
    http_x_forwarded_for: 5.5.5.5
    remote_addr: 10.10.10.10
    date: 2011-09-19 20:39:25 -0700
    request: GET /page1 HTTP/1.1
    """

  Scenario: Read a log file and store in db
    When I run `herdsman read --format format.yml --source sample.log --mongo-uri mongodb://localhost:27017/logs --mongo-collection sample`
    Then the collection: "sample" in db: "mongodb://localhost:27017/logs" should contain:
    | http_x_forwarded_for | remote_addr | date                          | request               |
    | 5.5.5.5              | 10.10.10.10 | [01/Sept/2011:18:00:00 +0000] | "GET /page1 HTTP/1.1" |
    | 8.8.8.8              | 10.10.10.10 | [01/Sept/2011:18:00:30 +0000] | "GET /page2 HTTP/1.1" |


