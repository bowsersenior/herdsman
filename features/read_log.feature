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

  Scenario: Read a log file
    When I run `herdsman read --source sample.log --fields http_x_forwarded_for,remote_addr,date,request`
    Then the output should contain:
    """
    {
      "http_x_forwarded_for": "5.5.5.5",
      "remote_addr": "10.10.10.10",
      "date": "[01/Sept/2011:18:00:00 +0000]",
      "request": "GET /page1 HTTP/1.1"
    }
    {
      "http_x_forwarded_for": "8.8.8.8",
      "remote_addr": "10.10.10.10",
      "date": "[01/Sept/2011:18:00:30 +0000]",
      "request": "GET /page2 HTTP/1.1"
    }
    """

  Scenario: Raise an error if fields arguments don't match log file
    When I run `herdsman read --source sample.log --fields http_x_forwarded_for,remote_addr,date`
    Then the output should contain:
    """
    ERROR
    Expected 4 fields, got 3
    """
    When I run `herdsman read --source sample.log --fields a,b,c,d,e,f`
    Then the output should contain:
    """
    ERROR
    Expected 4 fields, got 6
    """