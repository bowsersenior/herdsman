Feature: Process a log file, parsing it and then storing it in the DB
  As a developer,
  In order to facilitate analysis of information in a log file,
  I want to read a plain-text log file and have its contents parsed and stored in a database.


  Scenario: Process a log file
    Given a file named "sample.log" with:
    """
    5.5.5.5 10.10.10.10 [01/Sept/2011:18:00:00 +0000] "GET /page1 HTTP/1.1" 200 522 "http://www.example.com/somepage" "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; en-us) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1"
    8.8.8.8 10.10.10.10 [01/Sept/2011:18:00:30 +0000] "GET /page2 HTTP/1.1" 404 522 "http://www.example.com/anotherpage" "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0)"
    """
    And a file named "format.yml" with:
    """
    - http_x_forwarded_for
    - remote_addr
    - date
    - request
    - status
    - body_bytes_sent
    - http_referer
    - http_user_agent
    """
    When I run "herdsman --format format.yml sample.log"
    Then I should have the following fields in my database:
    | http_x_forwarded_for | remote_addr | date                          | request               | status | body_bytes_sent | http_referer                      | http_user_agent                                                                                                                   |
    | 5.5.5.5              | 10.10.10.10 | [01/Sept/2011:18:00:00 +0000] | "GET /page1 HTTP/1.1" | 200    | 522             | "http://www.example.com/somepage" | "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; en-us) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1" |


