require 'wit'

if ARGV.length == 0 
    #puts("usage: #{%0} <wit-access-token>")
    puts("usage: <wit-access-token>")
    exit 1
end

access_token = ARGV[0]
ARGV.shift

def first_value(obj, key)
    return nil unless obj.has_key? key
    val = obj[key][0]['value']
    return nil if val.nil?
    return val
end

$all_techniques = {
    'bad' => [
      'Are you Angry? Are you Sad?',
      'It is okay to feel bad sometimes, tell me Are you anxious? Are you sad?.',
    ],
    'anxious' => [
      'Okay, try counting to 10 slowly, while taking deep breaths',
      'Start by hearing you favorite music, and just oncentrate in the music while taking deep breaths.',
    ],
    'angry' => [
      'Start writing me, everything that comes to your mind',
      'Ask yourself questions. What happened that made you feel like that? Why it did bother you? What are you gonna do about it? If you do what you are thinking, What is the worst think that can happen, as well as the best thing?',
    ],
    'sad' => [
      'Change your thoughts, every time that you tell something that is bad, change it to a good one. Ex. "I am not good at anything" for "I am going to try it with a different method"',
      'Your thoughts can trigger and change your emotions, start changing your bad thoughts for good ones',
    ],
    'options' => [
        'Sure, try saying "I am feeling anxious", "I am angry", "I am very sad".',
    ],
    'happy' => [
        'I am glad that you are happy. Anytime you are feeling bad come see me',
    ],
    'default' => [
      'I am going to help you, but I need you to be more specific, Are you Angry? Anxious? Sad?',
    ],
  }

def handle_message(response)
    entities = response['entities']
    traits = response['traits']
    get_feeling = first_value(traits, 'getFeeling')
    get_options = first_value(traits, 'getOptions')
    greetings = first_value(traits, 'wit$greetings')
    sentiment = first_value(traits, 'wit$sentiment')
    thanks = first_value(traits, 'wit$thanks')
    bye = first_value(traits, 'wit$bye')
    category = first_value(entities, 'category:category')

    case 
    when greetings
        return 'Hey this is your psicological support robot YouCare :). Please tell me how are you feeling?'
    when get_feeling
        return $all_techniques[category || 'default'].sample
    when get_options
        return $all_techniques['options'].sample
    when sentiment
        return sentiment == 'positive' ? 'Glad I could help': 'I can help you with another technique. Try saying "Tell me another technique".'
    when thanks
        return 'Thnak you for trusting me'
    when bye
        return 'Bye, take care :), I will be here for you'
    else
        return 'Hey how are you feeling today? I will do my best to help you'
    end
end

client = Wit.new(access_token: access_token)
client.interactive(method(:handle_message))