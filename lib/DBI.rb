class DBI
  def initialize(uri, opts = {})
    opts = parse(uri).merge(opts)

    case opts[:dbms]
    when 'mysql'
      opts[:port] ||= 3306 unless opts[:host] == 'localhost'
      opts[:encoding] ||= 'utf8'

      begin
        @mysql = Mysql.init
        @mysql.options(Mysql::SET_CHARSET_NAME, opts[:encoding])
        @mysql.real_connect(opts[:host],
                            opts[:username],
                            opts[:password],
                            opts[:dbname].sub(/^\//, ''),
                            opts[:port],
                            opts[:socket])
        @mysql.query("set names #{opts[:encoding]}")
      rescue SocketError, Errno::ECONNREFUSED => e
        raise e.message
      end

      def execute(query)
        @result = @mysql.query(query)
        @output = Hash.new

        if(@result.nil?) then
          @output[:affected_rows] = @mysql.affected_rows
        else
          @output[:num_rows] = @result.num_rows
          @output[:rows] = Array.new
          @result.each_hash do |row|
            @output[:rows] << row
          end
        end

        @output
      end

      def close
        @mysql.close
      end

    when 'postgres'
      opts[:port] ||= 5432
      opts[:encoding] ||= 'utf-8'

      @postgres = PG::connect(:host => opts[:host],
                              :port => opts[:port],
                              :user => opts[:username],
                              :password => opts[:password],
                              :dbname => opts[:dbname].sub(/^\//, ''))
      begin
        @postgres.internal_encoding = opts[:encoding]
      rescue => e
        raise e.message
      end

      def execute(query)
        raise 'Query was empty' if query.blank?

        @result = @postgres.exec(query)
        @output = Hash.new

        if(@result.ntuples.zero?) then
          @output[:cmd_tuples] = @result.cmd_tuples
        else
          @output[:num_tuples] = @result.num_tuples
          @output[:tuples] = Array.new
          @result.each do |row|
            @output[:tuples] << row
          end
        end

        @output
      end

      def close
        @postgres.finish
      end
    end
  end


  def parse(uri)
    uri = URI.parse(uri)
    opts = Hash.new

    opts[:dbms] = uri.scheme
    unless uri.userinfo.nil? then
      userinfo = uri.userinfo.split(':')
      opts[:username] = userinfo[0]
      opts[:password] = userinfo[1]
    end
    opts[:host] = uri.host
    opts[:port] = uri.port
    opts[:dbname] = uri.path

    opts
  end

  private :parse
end
